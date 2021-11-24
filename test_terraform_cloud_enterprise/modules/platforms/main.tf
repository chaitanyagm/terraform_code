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

resource "azurerm_management_group" "platforms_mg" {
  display_name = local.management_group_name
}

module "management" {
    source = ".//management/"
    platforms_mg_id   = azurerm_management_group.platforms_mg.id
}

module "cyber" {
    source = ".//cyber/"
    platforms_mg_id   = azurerm_management_group.platforms_mg.id
}

module "hub" {
    source = ".//hub/"
    platforms_mg_id   = azurerm_management_group.platforms_mg.id
}

module "logging-monitor" {
    source = ".//logging-monitor/"
    platforms_mg_id   = azurerm_management_group.platforms_mg.id
}