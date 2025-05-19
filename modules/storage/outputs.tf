output "storage_account_id" {
  value = azurerm_storage_account.main.id
}

output "storage_account_name" {
  value = azurerm_storage_account.main.name
}

output "storage_account_primary_connection_string" {
  value     = azurerm_storage_account.main.primary_connection_string
  sensitive = true
}

output "storage_container_name" {
  value = azurerm_storage_container.main.name
}

output "storage_sas_url" {
  value = "https://${var.storage_account_name}.blob.core.windows.net/${var.storage_account_name}${data.azurerm_storage_account_sas.this.sas}"
  sensitive = true
}
