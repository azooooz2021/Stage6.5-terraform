variable "prefix" {
  description = "Prefix for all resources"
  type        = string
}

variable "location" {
  description = "Azure region where resources will be created"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vmss_id" {
  description = "ID of the Virtual Machine Scale Set"
  type        = string
}

variable "postgresql_server_id" {
  description = "ID of the PostgreSQL Flexible Server"
  type        = string
}

variable "appgw_id" {
  description = "ID of the Application Gateway"
  type        = string
}

variable "storage_account_id" {
  description = "ID of the Storage Account"
  type        = string
}

variable "key_vault_id" {
  description = "ID of the Key Vault"
  type        = string
}

variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
}

variable "alert_sms_country_code" {
  description = "Country code for SMS alerts"
  type        = string
  default     = "971"  # UAE country code
}

variable "alert_sms_number" {
  description = "Phone number for SMS alerts"
  type        = string
}

variable "window_size" {
  description = "Time window for alert evaluation in minutes"
  type        = number
  default     = 5
}

variable "cpu_threshold" {
  description = "CPU usage threshold percentage for alerts"
  type        = number
  default     = 80
}

variable "cpu_alert_severity" {
  description = "Severity level for CPU alerts (0-4, with 0 being the most severe)"
  type        = number
  default     = 2
}

variable "memory_threshold" {
  description = "Memory usage threshold percentage for alerts"
  type        = number
  default     = 80
}

variable "memory_threshold_bytes" {
  description = "Memory threshold in bytes (calculated based on VM size)"
  type        = number
}

variable "memory_alert_severity" {
  description = "Severity level for memory alerts (0-4, with 0 being the most severe)"
  type        = number
  default     = 2
}

variable "db_connection_threshold" {
  description = "Database connection count threshold for alerts"
  type        = number
  default     = 100
}

variable "db_storage_threshold" {
  description = "Database storage usage threshold percentage for alerts"
  type        = number
  default     = 80
}

variable "db_alert_severity" {
  description = "Severity level for database alerts (0-4, with 0 being the most severe)"
  type        = number
  default     = 1
}

variable "appgw_health_threshold" {
  description = "Application Gateway healthy host count threshold"
  type        = number
  default     = 1
}

variable "appgw_alert_severity" {
  description = "Severity level for Application Gateway alerts (0-4, with 0 being the most severe)"
  type        = number
  default     = 1
}

variable "storage_capacity_threshold" {
  description = "Storage capacity usage threshold percentage"
  type        = number
  default     = 80
}

variable "storage_capacity_threshold_bytes" {
  description = "Storage capacity threshold in bytes"
  type        = number
}

variable "storage_alert_severity" {
  description = "Severity level for storage alerts (0-4, with 0 being the most severe)"
  type        = number
  default     = 2
}

variable "log_retention_days" {
  description = "Number of days to retain logs"
  type        = number
  default     = 30
}
