output "application_gateway_id" {
  value = azurerm_application_gateway.main.id
}

output "application_gateway_name" {
  value = azurerm_application_gateway.main.name
}

output "backend_address_pool_ids" {
  value = [for pool in azurerm_application_gateway.main.backend_address_pool : pool.id]
}

output "public_ip_address" {
  value = azurerm_public_ip.appgw.ip_address
}
