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

resource "azurerm_ssh_public_key" "ssh_key" {
  name                = "terraform_ho02_ssh_key"
  resource_group_name = "terraform_ho02"
  location            = "westeurope"
  public_key          = file("id_rsa.pub")
}

/*
resource "azurerm_ssh_public_key" "ssh_key_2" {
  name                = "terraform_ho02_ssh_key_2"
  resource_group_name = "terraform_ho02"
  location            = "westeurope"
  public_key          = file("id_rsa.pub")
}
*/