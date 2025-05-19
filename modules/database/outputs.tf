output "postgresql_server_fqdn" {
  value = azurerm_postgresql_flexible_server.main.fqdn
}

output "postgresql_server_id" {
  value = azurerm_postgresql_flexible_server.main.id
}
