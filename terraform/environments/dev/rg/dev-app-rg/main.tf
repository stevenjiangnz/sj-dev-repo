module "resource_group" {
  source = "../../../../modules/resource_group"
  
  resource_group_name = "dev-general-app-ae-rg"
  location           = "australiaeast"
  tags = {
    Environment = "Development"
    ManagedBy   = "Terragrunt"
  }
}

output "resource_group_id" {
  value = module.resource_group.resource_group_id
}

output "resource_group_name" {
  value = module.resource_group.resource_group_name
}