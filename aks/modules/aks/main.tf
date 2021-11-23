locals {
  # Common tags to be assigned to all resources
  tags = {
    environment         = "nonprod"
    infra-app           = "infrastructure"
  }
}

resource "azurerm_resource_group" "aks_name" {
  name     = "aks-rg-1"
  location = "East US"
}

resource "azurerm_user_assigned_identity" "aks_identity" {
  location            = azurerm_resource_group.aks_name.location
  resource_group_name = azurerm_resource_group.aks_name.name
  name                = "aks-identity"
  tags                = local.tags
}

resource "azurerm_kubernetes_cluster" "aks_local_test" {
  name                = "aks_local_test_9112021-1"
  location            = azurerm_resource_group.aks_name.location
  resource_group_name = azurerm_resource_group.aks_name.name
  dns_prefix              = "aks-shared-v2"

  default_node_pool {
    name       = "default"
    node_count = 1
    vm_size    = "Standard_D2_v2"
  }

  # cluster UAMI
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id
  }
}


resource "kubernetes_namespace" "example_namespace" {
  metadata {
    annotations = {
      name = "example-annotation-1"
    }

    labels = {
      mylabel = "label-value-1"
    }

    name = "terraform-example-namespace-1"
  }
}


# provider "kubernetes" {
#   config_path = "/Users/chaitu/.kube/config"
#   config_context = azurerm_kubernetes_cluster.aks_local_test.name
# }


output "cluster" {
  description = "The AKS Cluster"
  # value       = azurerm_kubernetes_cluster.aks_local_test
  value = azurerm_kubernetes_cluster.aks_local_test.kube_config
}


# use TLS static certificate to authenticate
provider "kubernetes" {
  host                   = azurerm_kubernetes_cluster.aks_local_test.kube_config.0.host
  # username               = azurerm_kubernetes_cluster.aks_local_test.kube_config.0.username
  # password               = azurerm_kubernetes_cluster.aks_local_test.kube_config.0.password
  client_certificate     = base64decode(azurerm_kubernetes_cluster.aks_local_test.kube_config.0.client_certificate)
  client_key             = base64decode(azurerm_kubernetes_cluster.aks_local_test.kube_config.0.client_key)
  cluster_ca_certificate = base64decode(azurerm_kubernetes_cluster.aks_local_test.kube_config.0.cluster_ca_certificate)
} 


/*
resource "azurerm_kubernetes_cluster" "shared_aks" {
  name                = var.aks_cluster_name
  location            = var.aks_shared_rg.location
  resource_group_name = var.aks_shared_rg.name
  # Use this if purely private - no public FQDN
  # dns_prefix_private_cluster          = "aks-shared-v2"
  private_dns_zone_id     = var.aks_pdns.id
  dns_prefix              = "aks-shared-v2"
  kubernetes_version      = var.kubernetes_version
  private_cluster_enabled = true
  sku_tier                = var.sku_tier
  # Spot nodepools cannot be added to auto-upgradable clusters
  # automatic_channel_upgrade           = "node-image"
  node_resource_group                 = var.aks_nodepool_rg_name
  private_cluster_public_fqdn_enabled = true
  # Remove potential Security hole
  local_account_disabled = true
  addon_profile {
    # enable aci virtual node
    aci_connector_linux {
      enabled     = true
      subnet_name = "virtual-subnet"
    }
    # enable AGIC as add-on as it provides extra configurations https://docs.microsoft.com/en-us/azure/application-gateway/ingress-controller-overview
    ingress_application_gateway {
      enabled    = true
      gateway_id = azurerm_application_gateway.agic.id
    }
    # oms agent 
    oms_agent {
      enabled = true
    }
    # for compliance enhancement
    azure_policy {
      enabled = true
    }
  }


  # This is used for initial syspool creation, and would be migrated to spot instances eventually
  default_node_pool {
    name                         = "system"
    vm_size                      = "Standard_B2s"
    type                         = "VirtualMachineScaleSets"
    enable_auto_scaling          = true
    min_count                    = 1
    max_count                    = 3
    max_pods                     = 250
    availability_zones           = ["1", "2", "3"]
    enable_node_public_ip        = false
    orchestrator_version         = var.kubernetes_version
    only_critical_addons_enabled = true
    os_disk_size_gb              = 30
    os_disk_type                 = "Managed"
    vnet_subnet_id               = var.aks_subnets[index(var.aks_subnets.*.name, "private-subnet")].id
    # Dynamic Pod IP Allocation - one day when windows clusters might support it too
    # https://docs.microsoft.com/en-us/azure/aks/configure-azure-cni#register-the-podsubnetpreview-preview-feature
    # pod_subnet_id = var.aks_subnets[index(var.aks_subnets.*.name, "virtual-subnet")].id
    # enable_host_encryption = true
    tags              = var.tags
    ultra_ssd_enabled = false
    # Use CBLMariner when it becomes available - defaults to Ubuntu
    os_sku = "Ubuntu"
  }

  # cluster UAMI
  identity {
    type                      = "UserAssigned"
    user_assigned_identity_id = azurerm_user_assigned_identity.aks_identity.id
  }

  role_based_access_control {
    enabled = true
    azure_active_directory {
      managed                = true
      azure_rbac_enabled     = true
      admin_group_object_ids = var.admin_group_object_ids
    }
  }

  network_profile {
    network_plugin = "azure"
    network_mode   = "transparent"
    network_policy = "calico"
    outbound_type  = "userDefinedRouting"
  }

  // avoid redeployment on changes to the default nodepool
  lifecycle {
    ignore_changes = [
      default_node_pool[0].min_count,
      default_node_pool[0].max_count,
      addon_profile[0].oms_agent,
      # addon_profile[0].azure_policy
    ]
  }
  tags = var.tags
}

*/