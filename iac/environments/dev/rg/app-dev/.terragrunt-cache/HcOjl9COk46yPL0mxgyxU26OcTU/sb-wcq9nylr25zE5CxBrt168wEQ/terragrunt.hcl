include "root" {
  path = find_in_parent_folders()
}

terraform {
  source = "../../../../modules/resource_group"

  # Add extra_arguments block to handle the tags
#   extra_arguments "custom_vars" {
#     commands = get_terraform_commands_that_need_vars()

#     arguments = [
#       "-var", "tags=${jsonencode(local.tags)}"
#     ]
#   }
}

# locals {
#   tags = {
#     environment = "dev"
#     managed_by  = "terraform"
#     project     = "demo"
#   }
# }

inputs = {
  resource_group_name = "dev-app-australiaeast-rg"
  location           = "australiaeast"
}