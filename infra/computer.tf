resource "azurerm_linux_virtual_machine" "lvm" {
  admin_username        = "g_owino"
  location              = azurerm_resource_group.rg.location
  name                  = "IRMVM"
  network_interface_ids = [azurerm_network_interface.nic.id]
  resource_group_name   = azurerm_resource_group.rg.name
  size                  = "Standard_F8"
  provision_vm_agent    = true
  admin_ssh_key {
    public_key = file("~/.ssh/id_rsa.pub") # you need to generate ssh keys on your machine
    username   = "g_owino"
  }
  os_disk {
    name                 = "IRMVM-OSDisk"
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
    disk_size_gb = 64
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }

#   provisioner "remote-exec" {
#     inline = [
#       "sudo apt-get update",
#       "sudo apt-get install -y postgresql-client",
#       "sudo sh -c 'echo \"deb http://apt.postgresql.org/pub/repos/apt $(lsb_release -cs)-pgdg main\" >> /etc/apt/sources.list.d/pgdg.list'",
#       "wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -",
#       "sudo apt-get update",
#       "sudo apt-get install -y postgresql-12"
#       ]
#
#   }
}

resource "azurerm_dev_test_global_vm_shutdown_schedule" "shutdown" {
  virtual_machine_id    = azurerm_linux_virtual_machine.lvm.id
  location              = azurerm_resource_group.rg.location
  enabled               = true
  daily_recurrence_time = "1900"
  timezone              = "E. Africa Standard Time"

  notification_settings {
    enabled         = true
    time_in_minutes = "30"
    email           = "awino_g@tuta.io"
  }
}


output "public_ip_address_vm" {
  value = azurerm_linux_virtual_machine.lvm.public_ip_address
}