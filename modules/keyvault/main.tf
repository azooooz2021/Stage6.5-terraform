data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "main" {
  name                       = var.key_vault_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  tenant_id                  = data.azurerm_client_config.current.tenant_id
  sku_name                   = "premium"
  soft_delete_retention_days = 7

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "Create",
      "Get",
      "List"
    ]

    secret_permissions = [
      "Set",
      "Get",
      "Delete",
      "Purge",
      "Recover",
      "List"
    ]
  }
}

# Create secrets
resource "azurerm_key_vault_secret" "openai_key" {
  name         = "PROJ-OPENAI-API-KEY"
  value        = var.openai_key
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_name" {
  name         = "PROJ-DB-NAME"
  value        = var.db_name
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_username" {
  name         = "PROJ-DB-USER"
  value        = var.admin_username
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_password" {
  name         = "PROJ-DB-PASSWORD"
  value        = var.admin_password
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_host" {
  name         = "PROJ-DB-HOST"
  value        = var.db_host
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "db_port" {
  name         = "PROJ-DB-PORT"
  value        = var.db_port
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "storage_sas_url" {
  name         = "PROJ-AZURE-STORAGE-SAS-URL"
  value        = var.storage_sas_url
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "storage_container" {
  name         = "PROJ-AZURE-STORAGE-CONTAINER"
  value        = var.storage_container_name
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "chromadb_host" {
  name         = "PROJ-CHROMADB-HOST"
  value        = var.chromadb_host
  key_vault_id = azurerm_key_vault.main.id
}

resource "azurerm_key_vault_secret" "chromadb_port" {
  name         = "PROJ-CHROMADB-PORT"
  value        = var.chromadb_port
  key_vault_id = azurerm_key_vault.main.id
}
