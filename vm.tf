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


provisioner "remote-exec" {
    inline = [
      "touch /tmp/hello",
      "touch /tmp/hello1",
    ]
}
  }

