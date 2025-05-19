resource "azurerm_postgresql_flexible_server" "main" {
  name                = var.postgres_server_name
  resource_group_name = var.resource_group_name
  location            = var.location
  version             = "12"

  administrator_login           = var.admin_username
  administrator_password        = var.admin_password
  public_network_access_enabled = true

  zone         = "1"
  storage_mb   = 32768
  storage_tier = "P4"
  sku_name     = "B_Standard_B1ms"
  
  tags = {
    environment = "Production"
  }
}

# Firewall rule to allow all IPs (0.0.0.0 - 255.255.255.255)
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_all" {
  name             = "allow_all_ips"
  server_id        = azurerm_postgresql_flexible_server.main.id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "255.255.255.255"
}

# Run a script to create the table after the database is created
resource "null_resource" "create_table" {
  provisioner "local-exec" {
    command = <<EOT
      psql "host=${azurerm_postgresql_flexible_server.main.fqdn} port=5432 dbname=${var.db_name} user=${var.admin_username} password=${var.admin_password} sslmode=require" -c "CREATE TABLE IF NOT EXISTS advanced_chats (
        id TEXT PRIMARY KEY,
        name TEXT NOT NULL,
        file_path TEXT NOT NULL,
        last_update TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
        pdf_path TEXT,
        pdf_name TEXT,
        pdf_uuid TEXT
      );"
    EOT
  }
  depends_on = [
    azurerm_postgresql_flexible_server.main
  ]
}
