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