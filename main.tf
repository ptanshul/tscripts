terraform {
  required_version = ">= 1.1.0"
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "~> 2.65"
    }
  }

}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "bhsgroup" {
  location     = var.location
  name = var.resourceGroupName
  tags = var.tags
}

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


  resource "azurerm_public_ip" "bhspublicip" {
  name                = var.ipaddressname
  resource_group_name = azurerm_resource_group.bhsgroup.name
  location            = var.location
  allocation_method   = "Dynamic"

  tags = var.tags


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


resource "azurerm_linux_virtual_machine" "mybhsvm" {
  name                = var.vmname
  resource_group_name = azurerm_resource_group.bhsgroup.name
  location            = var.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.bhsnic.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = tls_private_key.bhstlskey.public_key_openssh
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"

  }
computer_name = var.vmname
disable_password_authentication = true


  }
