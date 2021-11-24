terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [ azurerm ]
    }
  }
}

locals {
  # Get Business unit name from folder name for Management Group & Subscription Creation
  management_group_name        = "${basename(abspath(path.module))}-mg"

}


resource "azurerm_management_group" "landing_zone_mg" {
  display_name = local.management_group_name
}

module "dna" {
    source            = ".//dna"
    landing_zone_mg_id   = azurerm_management_group.landing_zone_mg.id
    providers         = {
        azurerm = azurerm
    }
}
