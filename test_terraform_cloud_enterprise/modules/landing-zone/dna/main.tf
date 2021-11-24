terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [ azurerm ]
    }
  }
}

locals {
  # Get Business unit name from folder name for Management Group & Subscription Creation
  business_unit_name        = basename(abspath(path.module))

}

resource "azurerm_management_group" "landing_business_unit_mg" {
  display_name = "${local.business_unit_name}-bu-mg"
  parent_management_group_id = var.landing_zone_mg_id
}

module "prod" {
  source                    = ".//prod/"
  business_unit_name        = local.business_unit_name
  management_group_id       = azurerm_management_group.landing_business_unit_mg.id
}

# module "non-prod" {
#   source        = ".//non-prod/"
#   management_group_name = local.management_group_name
# }

# module "sandpit" {
#   source        = ".//sandpit/"
#   management_group_name = local.management_group_name
# }

