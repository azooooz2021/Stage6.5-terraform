variable "prefix" {
  description = "Prefix for resource names"
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

variable "vm_size" {
  description = "Size of the virtual machine"
  type        = string
}

variable "subnet_id" {
  description = "ID of the subnet for VM deployment"
  type        = string
}

variable "sig_image_id" {
  description = "ID of the Shared Image Gallery image to use"
  type        = string
}

variable "backend_address_pool_ids" {
  description = "IDs of the Application Gateway backend address pools"
  type        = list(string)
}
