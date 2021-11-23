locals {
  # Common tags to be assigned to all resources
  common_tags = {
      business-unit = "insurance"
      environment   = "prod"
  }
}

module "platforms" {
  source = "./modules/platforms"
  providers = {
      azurerm = azurerm.prod
  }
}

module "landing-zone" {
  source = "./modules/landing-zone"
  providers = {
      azurerm = azurerm.prod
  }
}
