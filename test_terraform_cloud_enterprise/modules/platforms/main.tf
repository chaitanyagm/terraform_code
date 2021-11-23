terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [ azurerm ]
    }
  }
}

module "management" {
  source = ".//management/"
}

module "cyber" {
  source = ".//cyber/"
}

module "hub" {
  source = ".//hub/"
}

module "logging-monitor" {
  source = ".//logging-monitor/"
}