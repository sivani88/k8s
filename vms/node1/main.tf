provider "azurerm" {
  features {}
}

# Generate SSH key pair
resource "tls_private_key" "vm-ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

data "azurerm_virtual_network" "vnet" {
  name                = var.vnet_address_space
  resource_group_name = data.azurerm_resource_group.rg.name
  //dns_servers         = ["172.59.1.1", "1.1.1.2"]
}

data "azurerm_subnet" "sub" {
  name                 = var.subnet_address_prefixes
  resource_group_name  = data.azurerm_resource_group.rg.name
  virtual_network_name = data.azurerm_virtual_network.vnet.name
  //address_prefixes     = ["172.59.1.0/24"]
}


resource "azurerm_network_security_group" "nsg-node1" {

  name                = "nsg-node1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  security_rule {
    name                       = "AllowSSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }

  tags = var.tags
}



resource "azurerm_network_interface" "vnic-node1" {
  name                = "vnic-node1"
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = data.azurerm_subnet.sub.id
    private_ip_address_allocation = "Static"
    private_ip_address            = "172.59.1.11"
    public_ip_address_id          = azurerm_public_ip.pip-node1.id
  }

  tags = var.tags
}


resource "azurerm_public_ip" "pip-node1" {

  name                = "pip-node1-linux"
  resource_group_name = data.azurerm_resource_group.rg.name
  location            = var.location
  allocation_method   = "Static"

  tags = var.tags
}


resource "azurerm_network_interface_security_group_association" "nsg-peer" {
  network_interface_id      = azurerm_network_interface.vnic-node1.id
  network_security_group_id = azurerm_network_security_group.nsg-node1.id
}


resource "azurerm_linux_virtual_machine" "vm" {

  name                            = "vm-linux-node1"
  resource_group_name             = data.azurerm_resource_group.rg.name
  location                        = var.location
  size                            = var.vm_size
  admin_username                  = var.admin_username
  disable_password_authentication = true

  admin_ssh_key {
    username   = var.admin_username
    public_key = tls_private_key.vm-ssh.public_key_openssh
  }

  network_interface_ids = [
    azurerm_network_interface.vnic-node1.id,
  ]

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Debian"
    offer     = "debian-12"
    sku       = "12"
    version   = "latest"
  }

  tags = var.tags
}



# Output the SSH private key
output "ssh_private_key" {
  value     = tls_private_key.vm-ssh.private_key_pem
  sensitive = true
}
