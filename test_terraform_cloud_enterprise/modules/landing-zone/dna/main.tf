terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [ azurerm ]
    }
  }
}

locals {
  # Get Business unit name from folder name for Management Group & Subscription Creation
  management_group_name     = "${basename(abspath(path.module))}-mg"
  business_unit_name        = basename(abspath(path.module))

}

module "prod" {
  source        = ".//prod/"
  management_group_name = local.management_group_name
  business_unit_name    = local.business_unit_name
}

# module "non-prod" {
#   source        = ".//non-prod/"
#   management_group_name = local.management_group_name
# }

# module "sandpit" {
#   source        = ".//sandpit/"
#   management_group_name = local.management_group_name
# }