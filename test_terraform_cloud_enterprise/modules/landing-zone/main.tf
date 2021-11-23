terraform {
  required_providers {
    azurerm = {
      configuration_aliases = [ azurerm ]
    }
  }
}

module "dna" {
    source = ".//dna"
    providers = {
        azurerm = azurerm
    }
}