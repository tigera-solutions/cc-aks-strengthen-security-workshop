resource "azurerm_virtual_network" "vnet" {
  name                = "azure"
  address_space       = ["10.0.0.0/16"]
  location            = var.location
  resource_group_name = var.resource_group_name 
}

resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = var.resource_group_name 
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "external_ip" {
  name                = "workshop-public-ip"
  resource_group_name = var.resource_group_name 
  location            = var.location
  allocation_method   = "Static"

  tags = {
    environment = "Production"
  }
}

resource "azurerm_network_interface" "nic" {
  name                = "workshop-nic"
  location            = var.location
  resource_group_name = var.resource_group_name 

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.external_ip.id
  }
}

resource "azurerm_linux_virtual_machine" "example" {
  name                = "workshop-machine"
  resource_group_name = var.resource_group_name 
  location            = var.location
  size                = "Standard_A1_v2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts"
    version   = "latest"
  }

  custom_data = base64encode(<<-EOF
              #!/bin/bash
              apt update && apt -y upgrade
              apt -y install docker.io
              sed -i '1s/^/force_color_prompt=yes\n/' ~/.bashrc
              curl -Lo tigera-scanner https://installer.calicocloud.io/tigera-scanner/v3.16.1-11/image-assurance-scanner-cli-linux-amd64
              chmod +x ./tigera-scanner
              mv ./tigera-scanner /usr/bin/
              EOF
  )
}