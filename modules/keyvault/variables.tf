variable "key_vault_name" {
  description = "The name of the Key Vault"
  type        = string
}

variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "vmss_principal_id" {
  description = "Principal ID of the VMSS for Key Vault access"
  type        = string
  default     = null
}

variable "openai_key" {
  description = "The OpenAI API key"
  type        = string
  sensitive   = true
}

variable "db_name" {
  description = "The name of the database"
  type        = string
}

variable "admin_username" {
  description = "The admin username for the PostgreSQL server"
  type        = string
}

variable "admin_password" {
  description = "The PostgreSQL admin password"
  type        = string
  sensitive   = true
}

variable "db_host" {
  description = "The host of the database"
  type        = string
}

variable "db_port" {
  description = "The port of the database"
  type        = string
}

variable "storage_sas_url" {
  description = "The SAS URL for the storage account"
  type        = string
  sensitive   = true
}

variable "storage_container_name" {
  description = "The name of the storage container"
  type        = string
}

variable "chromadb_host" {
  description = "The host of the ChromaDB"
  type        = string
}

variable "chromadb_port" {
  description = "The port of the ChromaDB"
  type        = string
}
