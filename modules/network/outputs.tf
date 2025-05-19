output "nsg_name" {
  value = azurerm_network_security_group.main.name
}

output "nsg_id" {
  value = azurerm_network_security_group.main.id
}

output "vnet_name" {
  value = azurerm_virtual_network.main.name
}

output "vnet_id" {
  value = azurerm_virtual_network.main.id
}

output "internal_subnet_id" {
  value = azurerm_subnet.internal.id
}

output "appgw_subnet_id" {
  value = azurerm_subnet.appgw.id
}
