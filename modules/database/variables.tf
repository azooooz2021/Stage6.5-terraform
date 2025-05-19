variable "location" {
  description = "Azure region to deploy resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "postgres_server_name" {
  description = "The name of the PostgreSQL flexible server"
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

variable "db_name" {
  description = "The name of the database"
  type        = string
}
