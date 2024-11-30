# terraform/environments/terragrunt.hcl
locals {
  # Load environment variables or common tags
  common_tags = {
    managed_by  = "terraform"
    project     = "sj-dev"
  }
}

inputs = {
  tags = local.common_tags
}