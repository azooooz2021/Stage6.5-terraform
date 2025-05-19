# 📊 Monitoring Module

This module implements comprehensive monitoring and alerting for the Azure Chatbot infrastructure.

## 🚀 Features

- 🔔 **Alert Action Group**: Centralized notification system for all alerts via email and SMS
- 📈 **Resource Monitoring**: CPU, memory, and health metrics for all infrastructure components
- 📊 **Database Monitoring**: Connection count and storage usage alerts
- 🌐 **Application Gateway Monitoring**: Health and performance metrics
- 💾 **Storage Monitoring**: Capacity and performance alerts
- 📝 **Centralized Logging**: Log Analytics workspace for aggregating logs from all resources
- 🔍 **Application Insights**: Application performance monitoring for the chatbot application

## 📋 Resources Created

- Azure Monitor Action Group
- Azure Monitor Metric Alerts
- Log Analytics Workspace
- Application Insights
- Diagnostic Settings for all resources

## 📥 Input Variables

| Name | Description | Type | Default |
|------|-------------|------|---------|
| prefix | Prefix for all resources | string | - |
| location | Azure region where resources will be created | string | - |
| resource_group_name | Name of the resource group | string | - |
| vmss_id | ID of the Virtual Machine Scale Set | string | - |
| postgresql_server_id | ID of the PostgreSQL Flexible Server | string | - |
| appgw_id | ID of the Application Gateway | string | - |
| storage_account_id | ID of the Storage Account | string | - |
| key_vault_id | ID of the Key Vault | string | - |
| alert_email | Email address for alert notifications | string | - |
| alert_sms_country_code | Country code for SMS alerts | string | "971" |
| alert_sms_number | Phone number for SMS alerts | string | - |
| window_size | Time window for alert evaluation in minutes | number | 5 |
| cpu_threshold | CPU usage threshold percentage for alerts | number | 80 |
| cpu_alert_severity | Severity level for CPU alerts | number | 2 |
| memory_threshold | Memory usage threshold percentage for alerts | number | 80 |
| memory_threshold_bytes | Memory threshold in bytes | number | - |
| db_connection_threshold | Database connection count threshold for alerts | number | 100 |
| db_storage_threshold | Database storage usage threshold percentage for alerts | number | 80 |
| db_alert_severity | Severity level for database alerts | number | 1 |
| appgw_health_threshold | Application Gateway healthy host count threshold | number | 1 |
| appgw_alert_severity | Severity level for Application Gateway alerts | number | 1 |
| storage_capacity_threshold | Storage capacity usage threshold percentage | number | 80 |
| storage_capacity_threshold_bytes | Storage capacity threshold in bytes | number | - |
| storage_alert_severity | Severity level for storage alerts | number | 2 |
| log_retention_days | Number of days to retain logs | number | 30 |

## 📤 Output Values

| Name | Description |
|------|-------------|
| action_group_id | ID of the created action group |
| log_analytics_workspace_id | ID of the Log Analytics Workspace |
| application_insights_id | ID of the Application Insights resource |
| application_insights_instrumentation_key | Instrumentation key for Application Insights |
| application_insights_connection_string | Connection string for Application Insights |

## 🔄 Dependencies

This module depends on all other infrastructure modules as it requires their resource IDs for monitoring.

## 📝 Usage Example

```hcl
module "monitoring" {
  source              = "./modules/monitoring"
  prefix              = "chatbot"
  location            = "uaenorth"
  resource_group_name = azurerm_resource_group.main.name
  
  # Resource IDs for monitoring
  vmss_id             = module.compute.vmss_id
  postgresql_server_id = module.database.postgresql_server_id
  appgw_id            = module.appgw.appgw_id
  storage_account_id  = module.storage.storage_account_id
  key_vault_id        = module.keyvault.key_vault_id
  
  # Alert configuration
  alert_email         = "admin@example.com"
  alert_sms_number    = "5551234567"
  memory_threshold_bytes = 1073741824  # 1GB
  storage_capacity_threshold_bytes = 85899345920  # 80GB
}
```
