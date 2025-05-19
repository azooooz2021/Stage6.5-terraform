locals {
  # Common tags for all resources
  common_tags = {
    Environment = var.prefix
    Project     = "Azure Chatbot"
    ManagedBy   = "Terraform"
  }
  
  # Construct the SIG image ID from variables instead of hardcoding
  sig_image_id = "/subscriptions/${var.subscription_id}/resourceGroups/${var.sig_resource_group_name}/providers/Microsoft.Compute/galleries/${var.sig_gallery_name}/images/${var.sig_image_definition}/versions/${var.sig_image_version}"
  
  # Database connection settings
  db_connection = {
    port            = var.DB-PORT
    sslmode         = var.db_ssl_mode
    connect_timeout = var.db_connect_timeout
  }
  
  # Key Vault access policies
  key_vault_permissions = {
    key_permissions = [
      "Get",
      "List"
    ]
    secret_permissions = [
      "Get",
      "List"
    ]
  }
}
