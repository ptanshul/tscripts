resource "azurerm_virtual_network" "bhsnetwork" {
  name                = var.vnetname
  location            = var.location
  resource_group_name = azurerm_resource_group.bhsgroup.name
  address_space       = ["10.0.0.0/16"]
  tags = var.tags
}


resource "azurerm_subnet" "bhssubnet" {
	name = var.subnetname
	resource_group_name = azurerm_resource_group.bhsgroup.name
	virtual_network_name = azurerm_virtual_network.bhsnetwork.name
	address_prefixes = ["10.0.2.0/24"]
}
