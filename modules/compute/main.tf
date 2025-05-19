# ChromaDB VM
resource "azurerm_public_ip" "chromadb" {
  name                = "${var.prefix}-public-ip-chromadb"
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku                 = "Basic"
}

resource "azurerm_network_interface" "chromadb" {
  name                = "${var.prefix}-nic-chromadb"
  resource_group_name = var.resource_group_name
  location            = var.location

  ip_configuration {
    name                          = "ipconfig-chromadb"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.chromadb.id
  }
}

resource "azurerm_linux_virtual_machine" "chromadb_vm" {
  name                = "chromadb-vm"
  resource_group_name = var.resource_group_name
  location            = var.location
  size                = var.vm_size
  admin_username      = "azureuser"
  network_interface_ids = [
    azurerm_network_interface.chromadb.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub") # Replace with your actual public key path
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }

  custom_data = base64encode(<<EOF
#cloud-config
runcmd:
  - apt update && apt install -y python3-pip python3-venv git docker.io
  - usermod -aG docker azureuser
  - sudo chown azureuser:azureuser /home/azureuser/.bashrc
  - sudo -u azureuser bash -c 'pip install --upgrade pip'
  - |
    cat <<'EOL' | tee /etc/systemd/system/chromadb.service
    [Unit]
    Description=Chroma via Docker
    After=docker.service
    Requires=docker.service

    [Service]
    Restart=always
    ExecStartPre=-/usr/bin/docker rm -f chromadb
    ExecStart=/usr/bin/docker run --name chromadb -p 8000:8000 -e CHROMA_SERVER_HOST=0.0.0.0 ghcr.io/chroma-core/chroma:0.5.23
    ExecStop=/usr/bin/docker stop chromadb

    [Install]
    WantedBy=multi-user.target
    EOL
  - systemctl daemon-reload
  - systemctl enable chromadb
  - systemctl start chromadb
EOF
  )
  
  tags = {
    environment = "dev"
  }
}

# VMSS for application
resource "azurerm_linux_virtual_machine_scale_set" "chatbot_vmss" {
  name                            = "${var.prefix}-vmss"
  location                        = var.location
  resource_group_name             = var.resource_group_name
  sku                             = "Standard_B1ms"
  instances                       = 2
  admin_username                  = "azureuser"
  disable_password_authentication = true

  source_image_id = var.sig_image_id
  
  
  admin_ssh_key {
    username   = "azureuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  upgrade_mode = "Automatic"

  identity {
    type = "SystemAssigned"
  }

  network_interface {
    name    = "vmss-nic"
    primary = true

    ip_configuration {
      name      = "internal-ipconfig"
      primary   = true
      subnet_id = var.subnet_id
      application_gateway_backend_address_pool_ids = var.backend_address_pool_ids
    }
  }

  tags = {
    environment = "Production"
  }
}
