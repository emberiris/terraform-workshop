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