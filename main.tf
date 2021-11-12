terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=2.71.0"
    }
  }
}

provider "azurerm" {
  subscription_id = var.subscription_id
  tenant_id       = var.tenant_id
  //For Service Principle based authentication
  client_id     = var.client_id
  client_secret = var.client_secret
  //use_msi = true // set to true for using System Assigned Managed Identities

  features {}
}



output "cluster" {
  description = "The AKS Cluster"
  value       = module.aks.cluster
  # sensitive = true
}
