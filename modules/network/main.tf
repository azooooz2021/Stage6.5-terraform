resource "azurerm_network_security_group" "main" {
  name                = "${var.prefix}-nsg"
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = {
      allow-ssh       = { priority = 1000, port = 22 }
      allow-backend   = { priority = 1001, port = 5000 }
      allow-http      = { priority = 1002, port = 80 }
      allow-streamlit = { priority = 1003, port = 8501 }
      allow-chromadb  = { priority = 1004, port = 8000 }
    }

    content {
      name                       = security_rule.key
      priority                   = security_rule.value.priority
      direction                  = "Inbound"
      access                     = "Allow"
      protocol                   = "Tcp"
      source_port_range          = "*"
      destination_port_range     = tostring(security_rule.value.port)
      source_address_prefix      = "*"
      destination_address_prefix = "*"
    }
  }
  depends_on = [var.resource_group_id]
}

resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-vnet"
  location            = var.location
  resource_group_name = var.resource_group_name
  address_space       = ["10.0.0.0/16"]

  depends_on = [var.resource_group_id]
  
  tags = {
    environment = "Production"
  }
}

# Internal subnet for all VMs
resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Associate NSG to the internal subnet
resource "azurerm_subnet_network_security_group_association" "internal_nsg" {
  subnet_id                 = azurerm_subnet.internal.id
  network_security_group_id = azurerm_network_security_group.main.id
}

# App Gateway subnet
resource "azurerm_subnet" "appgw" {
  name                 = "appgw-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.2.0/24"]
}
