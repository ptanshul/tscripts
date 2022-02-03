resource "azurerm_network_security_group" "bhsnsg" {
  name                = var.nsgname
  location            = var.location
  resource_group_name = azurerm_resource_group.bhsgroup.name

  security_rule {
    name                       = "SSH"
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
