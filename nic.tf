
resource "azurerm_network_interface" "bhsnic" {
  name                = var.nicname
  location            = var.location
  resource_group_name = azurerm_resource_group.bhsgroup.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.bhssubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = azurerm_public_ip.bhspublicip.id

  }

    tags = var.tags	
}

    resource "azurerm_network_interface_security_group_association" "bhsassociation" {
  network_interface_id      = azurerm_network_interface.bhsnic.id
  network_security_group_id = azurerm_network_security_group.bhsnsg.id
}

