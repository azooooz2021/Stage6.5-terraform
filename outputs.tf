output "resource_group_name" {
  value = azurerm_resource_group.main.name
}

output "nsg_name" {
  value = module.network.nsg_name
}

output "network_security_group_id" {
  value = module.network.nsg_id
}

output "vnet_name" {
  value = module.network.vnet_name
}

output "vnet_id" {
  value = module.network.vnet_id
}

output "postgresql_server_fqdn" {
  value = module.database.postgresql_server_fqdn
}

output "application_gateway_ip" {
  value = module.appgw.public_ip_address
}

output "chromadb_ip" {
  value = module.compute.chromadb_public_ip
}

# Monitoring outputs
output "log_analytics_workspace_id" {
  value = module.monitoring.log_analytics_workspace_id
  description = "ID of the Log Analytics Workspace"
}

output "application_insights_id" {
  value = module.monitoring.application_insights_id
  description = "ID of the Application Insights resource"
}

output "action_group_id" {
  value = module.monitoring.action_group_id
  description = "ID of the monitoring action group"
}
