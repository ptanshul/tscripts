
  resource "azurerm_public_ip" "bhspublicip" {
  name                = var.ipaddressname
  resource_group_name = azurerm_resource_group.bhsgroup.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = var.tags
}
