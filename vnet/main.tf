data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}


resource "azurerm_virtual_network" "vnet_pfsense" {
  name                = var.vnet_name
  location            = var.location
  resource_group_name = data.azurerm_resource_group.rg.name
  address_space       = [var.vnet_address_space]

  tags = {
    env = var.environment
  }
}

