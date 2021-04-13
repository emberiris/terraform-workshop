//Terraform configuration

terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = ">= 2.26"
    }
   }
   backend "azurerm" {
    resource_group_name   = "terraform_ho02"
    storage_account_name  = "ho02terraformplatform"
    container_name        = "tfstate"
    key                   = "terraform.tfstate"
   }  
}

provider "azurerm" {
  features {}
}

//Variables declaration

variable "rsg_name" { //Variable declarada y llamada en el tf-vars, cogerá el valor de allí, si no la declaramos, cogerá valor default.
  type = string
  //default = "terraform_ho02"
}

variable "prefix" { //Variable in-line, nos la pedirá la consola, si descomentamos default, cogerá ese valor
  type = string
  //default = "tfho03"
}


//Data-Source declaration
data "azurerm_resource_group" "rsg_datasource" {
  name = var.rsg_name  //Llamada de variable "rsg_name" usando var.nombre_de_la_variable
}


//Resources declaration


resource "azurerm_virtual_network" "main" {
  name                = "${var.prefix}-network" //Interpolamos una variable,cogera el valor de var.prefix y lo añadira a -network  (tfho03-network)
  address_space       = ["10.0.0.0/16"]
  location            = data.azurerm_resource_group.rsg_datasource.location //Usamos el location del rsg a través del datasource
  resource_group_name = data.azurerm_resource_group.rsg_datasource.name //Usamos el nombre del rsg a través del datasource, también opdemos usar var.rsg_name directamente
}

resource "azurerm_subnet" "internal" {
  name                 = "internal"
  resource_group_name  = var.rsg_name //Llamamos al nombre por la variable
  virtual_network_name = azurerm_virtual_network.main.name //Declaramos en que VNET se despliega la subnet, esto es una dependencia implicita, requerimos de que el resource de vnet se termine antes que la subnet
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_network_interface" "main" {
  name                = "${var.prefix}-nic"
  location            = data.azurerm_resource_group.rsg_datasource.location
  resource_group_name = var.rsg_name

  ip_configuration {
    name                          = "testconfiguration1"
    subnet_id                     = azurerm_subnet.internal.id
    private_ip_address_allocation = "Dynamic"
  }
}

resource "azurerm_virtual_machine" "main" {
  name                  = "${var.prefix}-vm"
  location              = data.azurerm_resource_group.rsg_datasource.location
  resource_group_name   = var.rsg_name
  network_interface_ids = [azurerm_network_interface.main.id] //Otra dependencia implicita
  vm_size               = "Standard_DS1_v2"
  
  delete_os_disk_on_termination = true
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "16.04-LTS"
    version   = "latest"
  }

  storage_os_disk {
    name              = "myosdisk1"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = "hostname"
    admin_username = "testadmin"
    admin_password = "Password1234!"  //Recordemos que esto se almacena en texto claro en el terraform-state. veremos algunas solucione más adelante
  }

  os_profile_linux_config {
    disable_password_authentication = false
  }

  tags = {
    environment = "staging"
  }

  depends_on = [
    azurerm_network_interface.main  //Aunque redundante por la dependencia implicita anterior, nos sirve para ver como es una dependencia explicita y como se diferencia de la anterior
  ]
}

//Outputs declaration

output "network_interface_private_ip" {
  description = "Private IP addresses of the vm nics"
  value       = azurerm_network_interface.main.*.private_ip_address
}


