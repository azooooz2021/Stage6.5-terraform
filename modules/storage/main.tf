resource "azurerm_storage_account" "main" {
  name                     = var.storage_account_name
  resource_group_name      = var.resource_group_name
  location                 = var.location
  account_tier             = "Standard"
  account_replication_type = "LRS"

  tags = {
    environment = "staging"
  }
}

resource "azurerm_storage_container" "main" {
  name                  = var.storage_account_name
  storage_account_id    = azurerm_storage_account.main.id
  container_access_type = "private"
}

data "azurerm_storage_account_sas" "this" {
  connection_string = azurerm_storage_account.main.primary_connection_string
  https_only        = true 
  start             = timestamp()
  expiry            = timeadd(timestamp(), "720h")
  signed_version    = "2022-11-02"
  
  resource_types {
    service   = true
    container = true
    object    = true
  }
  
  services {
    blob  = true
    queue = false
    table = false
    file  = false
  }
  
  permissions {
    read    = true
    write   = true
    delete  = true
    list    = true
    add     = true
    create  = true
    update  = true
    process = true
    tag     = true
    filter  = true
  }
}
