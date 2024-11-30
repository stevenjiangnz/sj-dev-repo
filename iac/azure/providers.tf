terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "prod-general-ae-rg"
    storage_account_name = "prodtf01aesa"
    container_name      = "tfstate"
    key                 = "terraform.tfstate"
  }
}

provider "azurerm" {
  features {}
}