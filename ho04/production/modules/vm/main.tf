# Create a Linux virtual machine
resource "azurerm_virtual_machine" "vm" {
  name                  = var.vm_name
  location              = var.location
  resource_group_name   = var.rsg
  network_interface_ids = var.network_interface_id #[azurerm_network_interface.nic.id]
  vm_size               = var.vm_size

  storage_os_disk {
    name              = "${var.vm_name}-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Premium_LRS"
  }

  storage_image_reference {
    publisher = var.publisher #"Canonical"
    offer     = var.offer #"UbuntuServer"
    sku       = var.sku #"16.04.0-LTS"
    version   = var.version_image #"latest"
  }

  os_profile {
    computer_name  = "${var.vm_name}-os-profile"
    admin_username = var.adm_username
    admin_password = var.adm_pswd
    custom_data    = base64encode(data.template_file.vm-cloud-init.rendered)
  }

  os_profile_linux_config {
    disable_password_authentication = var.disable_password_authentication
  }

  depends_on = [
    var.dependencies #azurerm_key_vault.secrets_vault
  ]
}

data "template_file" "vm-cloud-init" {
  template = file("${path.module}/user-data.sh")
}