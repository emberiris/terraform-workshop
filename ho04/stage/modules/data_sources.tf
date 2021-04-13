data "azurerm_resource_group" "rsg_datasource" {
  name = var.rsg_name 
}

data "azurerm_client_config" "current" {
}

data "template_file" "linux-vm-cloud-init" {
  template = file("${var.user_data_file}")
}