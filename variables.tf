variable "subscription_id" {
  description = "value of the subscription id"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "prefix" {
  description = "value of the prefix"
  type        = string
}

variable "vm_size" {
  description = "value of the vm size"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account"
  type        = string
}

variable "vnet_name" {
  description = "The name of the virtual network"
  type        = string
}

variable "subnet_name" {
  description = "The name of the subnet"
  type        = string
  default     = "main-postgres-subnet"
}

#########################################
# Monitoring information
#########################################
variable "alert_email" {
  description = "Email address for alert notifications"
  type        = string
}

variable "alert_sms_number" {
  description = "Phone number for SMS alerts"
  type        = string
}

variable "memory_threshold_bytes" {
  description = "Memory threshold in bytes for VM alerts"
  type        = number
  default     = 1073741824  # 1GB as default
}

variable "storage_capacity_threshold_bytes" {
  description = "Storage capacity threshold in bytes"
  type        = number
  default     = 85899345920  # 80GB as default
}

#########################################
#image information
#########################################

variable "sig_image_id" {
  description = "The ID of the Shared Image Gallery image version to use for VMSS"
  type        = string
}

variable "sig_image_version" {
  description = "Version of the SIG image to use"
  type        = string
}

variable "sig_resource_group_name" {
  description = "Resource group name containing the Shared Image Gallery"
  type        = string
  default     = "image-RG2"
}

variable "sig_gallery_name" {
  description = "Name of the Shared Image Gallery"
  type        = string
  default     = "myGallery"
}

variable "sig_image_definition" {
  description = "Name of the image definition in the Shared Image Gallery"
  type        = string
  default     = "myImageDefinintion"
}

#########################################
#database information
#########################################
variable "admin_username" {
  description = "The admin username for the PostgreSQL server"
  type        = string
}

variable "admin_password" {
  description = "The PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "postgres_server_name" {
  description = "The name of the PostgreSQL flexible server"
  type        = string
}

variable "DB-name" {
  description = "The name of the database"
  type        = string
}

variable "DB-host" {
  description = "The host of the database"
  type        = string
}

variable "db_ssl_mode" {
  description = "SSL mode for database connection"
  type        = string
  default     = "require"
}

variable "db_connect_timeout" {
  description = "Connection timeout for database in seconds"
  type        = number
  default     = 15
}

#########################################
#Keyvault information
#########################################
variable "ket-vault-name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "OpenAIkey" {
  description = "The OpenAI API key"
  type        = string
  sensitive   = true
}

variable "DB-HOST" {  
  description = "The host of the database"
  type        = string
}

variable "DB-PORT" {
  description = "The port of the database"
  type        = string
}

variable "CHROMADB-PORT" {
  description = "The port of the chroma database"
  type        = string
}
