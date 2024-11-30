remote_state {
  backend = "azurerm"
  generate = {
    path      = "backend.tf"
    if_exists = "overwrite_terragrunt"
  }
  config = {
    resource_group_name  = "prod-general-ae-rg"
    storage_account_name = "prodtf01aesa"
    container_name      = "tfstate"
    key                 = "${path_relative_to_include()}/terraform.tfstate"
  }
}

generate "provider" {
  path      = "provider.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
provider "azurerm" {
  features {}
}

terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
}
EOF
}

inputs = {
  environment = "prod"
  location    = "uaenorth"
  tags = {
    ManagedBy = "Terragrunt"
    Environment = "Production"
  }
}