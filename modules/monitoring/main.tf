resource "azurerm_monitor_action_group" "main" {
  name                = "${var.prefix}-actiongroup"
  resource_group_name = var.resource_group_name
  short_name          = "ag${var.prefix}"

  email_receiver {
    name                    = "admin"
    email_address           = var.alert_email
    use_common_alert_schema = true
  }

  sms_receiver {
    name         = "oncall"
    country_code = var.alert_sms_country_code
    phone_number = var.alert_sms_number
  }
}

# VM CPU Usage Alert
resource "azurerm_monitor_metric_alert" "vm_cpu" {
  name                = "${var.prefix}-vm-cpu-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Action will be triggered when CPU usage exceeds ${var.cpu_threshold}% for ${var.window_size} minutes"
  frequency           = "PT1M"
  window_size         = "PT${var.window_size}M"
  severity            = var.cpu_alert_severity

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Percentage CPU"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.cpu_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# VM Memory Usage Alert
resource "azurerm_monitor_metric_alert" "vm_memory" {
  name                = "${var.prefix}-vm-memory-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.vmss_id]
  description         = "Action will be triggered when memory usage exceeds ${var.memory_threshold}% for ${var.window_size} minutes"
  frequency           = "PT1M"
  window_size         = "PT${var.window_size}M"
  severity            = var.memory_alert_severity

  criteria {
    metric_namespace = "Microsoft.Compute/virtualMachineScaleSets"
    metric_name      = "Available Memory Bytes"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = var.memory_threshold_bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Database Connection Alert
resource "azurerm_monitor_metric_alert" "db_connections" {
  name                = "${var.prefix}-db-connections-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.postgresql_server_id]
  description         = "Action will be triggered when database connections exceed ${var.db_connection_threshold}"
  frequency           = "PT1M"
  window_size         = "PT${var.window_size}M"
  severity            = var.db_alert_severity

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "active_connections"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.db_connection_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Database Storage Alert
resource "azurerm_monitor_metric_alert" "db_storage" {
  name                = "${var.prefix}-db-storage-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.postgresql_server_id]
  description         = "Action will be triggered when database storage exceeds ${var.db_storage_threshold}%"
  frequency           = "PT1M"
  window_size         = "PT${var.window_size}M"
  severity            = var.db_alert_severity

  criteria {
    metric_namespace = "Microsoft.DBforPostgreSQL/flexibleServers"
    metric_name      = "storage_percent"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.db_storage_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Application Gateway Health Alert
resource "azurerm_monitor_metric_alert" "appgw_health" {
  name                = "${var.prefix}-appgw-health-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.appgw_id]
  description         = "Action will be triggered when Application Gateway health drops below ${var.appgw_health_threshold}%"
  frequency           = "PT1M"
  window_size         = "PT${var.window_size}M"
  severity            = var.appgw_alert_severity

  criteria {
    metric_namespace = "Microsoft.Network/applicationGateways"
    metric_name      = "HealthyHostCount"
    aggregation      = "Average"
    operator         = "LessThan"
    threshold        = var.appgw_health_threshold
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Storage Account Capacity Alert
resource "azurerm_monitor_metric_alert" "storage_capacity" {
  name                = "${var.prefix}-storage-capacity-alert"
  resource_group_name = var.resource_group_name
  scopes              = [var.storage_account_id]
  description         = "Action will be triggered when storage capacity exceeds ${var.storage_capacity_threshold}%"
  frequency           = "PT1M"
  window_size         = "PT1H"  # Storage metrics require at least 1 hour window
  severity            = var.storage_alert_severity

  criteria {
    metric_namespace = "Microsoft.Storage/storageAccounts"
    metric_name      = "UsedCapacity"
    aggregation      = "Average"
    operator         = "GreaterThan"
    threshold        = var.storage_capacity_threshold_bytes
  }

  action {
    action_group_id = azurerm_monitor_action_group.main.id
  }
}

# Log Analytics Workspace for centralized logging
resource "azurerm_log_analytics_workspace" "main" {
  name                = "${replace(var.prefix, ".", "")}loganalytics"
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = var.log_retention_days
}

# Application Insights for application monitoring
resource "azurerm_application_insights" "main" {
  name                = "${replace(var.prefix, ".", "")}appinsights"
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = "web"
  workspace_id        = azurerm_log_analytics_workspace.main.id
}

# Diagnostic settings for VMSS
resource "azurerm_monitor_diagnostic_setting" "vmss" {
  name                       = "${var.prefix}-vmss-diag"
  target_resource_id         = var.vmss_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic settings for PostgreSQL
resource "azurerm_monitor_diagnostic_setting" "postgresql" {
  name                       = "${var.prefix}-postgresql-diag"
  target_resource_id         = var.postgresql_server_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic settings for Application Gateway
resource "azurerm_monitor_diagnostic_setting" "appgw" {
  name                       = "${var.prefix}-appgw-diag"
  target_resource_id         = var.appgw_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "ApplicationGatewayAccessLog"
  }

  enabled_log {
    category = "ApplicationGatewayPerformanceLog"
  }

  enabled_log {
    category = "ApplicationGatewayFirewallLog"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}

# Diagnostic settings for Key Vault
resource "azurerm_monitor_diagnostic_setting" "keyvault" {
  name                       = "${var.prefix}-keyvault-diag"
  target_resource_id         = var.key_vault_id
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enabled_log {
    category = "AuditEvent"
  }

  metric {
    category = "AllMetrics"
    enabled  = true
  }
}
