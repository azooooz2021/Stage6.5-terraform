terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "4.27.0"
    }
    postgresql = {
      source  = "cyrilgdn/postgresql"
      version = ">= 1.22.0"
    }
  }
}

provider "azurerm" {
  features {
    key_vault {
      purge_soft_deleted_secrets_on_destroy = true
      recover_soft_deleted_secrets          = true
    }
  }
  subscription_id = var.subscription_id
}

data "azurerm_client_config" "current" {}

provider "postgresql" {
  host            = module.database.postgresql_server_fqdn
  port            = var.DB-PORT
  database        = var.DB-name
  username        = var.admin_username
  password        = var.admin_password
  sslmode         = local.db_connection.sslmode
  connect_timeout = local.db_connection.connect_timeout
}

# Resource Group
resource "azurerm_resource_group" "main" {
  name     = var.resource_group_name
  location = var.location
  tags     = local.common_tags
}

# Network Module
module "network" {
  source              = "./modules/network"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  resource_group_id   = azurerm_resource_group.main.id
}

# Application Gateway Module
module "appgw" {
  source              = "./modules/appgw"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  appgw_subnet_id     = module.network.appgw_subnet_id

  depends_on = [module.network]
}

# Database Module
module "database" {
  source              = "./modules/database"
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  postgres_server_name = var.postgres_server_name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  db_name             = var.DB-name

  depends_on = [azurerm_resource_group.main]
}

# Storage Module
module "storage" {
  source              = "./modules/storage"
  storage_account_name = var.storage_account_name
  resource_group_name = azurerm_resource_group.main.name
  location            = var.location

  depends_on = [azurerm_resource_group.main]
}

# Compute Module
module "compute" {
  source              = "./modules/compute"
  prefix              = var.prefix
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  vm_size             = var.vm_size
  subnet_id           = module.network.internal_subnet_id
  sig_image_id        = local.sig_image_id
  backend_address_pool_ids = module.appgw.backend_address_pool_ids

  depends_on = [
    module.network,
    module.appgw
  ]
}

# Key Vault Module
module "keyvault" {
  source              = "./modules/keyvault"
  key_vault_name      = var.ket-vault-name
  location            = var.location
  resource_group_name = azurerm_resource_group.main.name
  
  # We'll set this to null initially and update it after VMSS is created
  vmss_principal_id   = null
  
  # Database related secrets
  db_name             = var.DB-name
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  db_host             = var.DB-HOST
  db_port             = var.DB-PORT
  
  # Storage related secrets
  storage_sas_url     = module.storage.storage_sas_url
  storage_container_name = module.storage.storage_container_name
  
  # ChromaDB related secrets
  chromadb_host       = module.compute.chromadb_public_ip
  chromadb_port       = var.CHROMADB-PORT
  
  # OpenAI key
  openai_key          = var.OpenAIkey

  depends_on = [
    module.database,
    module.storage
  ]
}

# Add VMSS access policy to Key Vault after VMSS is created
resource "azurerm_key_vault_access_policy" "vmss_policy" {
  key_vault_id = module.keyvault.key_vault_id
  tenant_id    = data.azurerm_client_config.current.tenant_id
  object_id    = module.compute.vmss_principal_id

  key_permissions = local.key_vault_permissions.key_permissions
  secret_permissions = local.key_vault_permissions.secret_permissions
  
  depends_on = [
    module.keyvault,
    module.compute
  ]
}
