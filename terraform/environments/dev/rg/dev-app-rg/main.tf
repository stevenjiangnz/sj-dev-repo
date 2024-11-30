locals {
  name     = "dev-apps-ae-rg"
  location = "australiaeast"
  tags = {
    ManagedBy    = "Terragrunt"
    Environment  = "dev"
  }
}

resource "azurerm_resource_group" "rg" {
  name     = local.name
  location = local.location
  tags     = local.tags
}