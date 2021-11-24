data "azurerm_billing_mca_account_scope" "get_billing_scope" {
  billing_account_name = var.billing_account_name
  billing_profile_name = var.billing_profile_name
  invoice_section_name = var.invoice_section_name
}

resource "azurerm_subscription" "create_subscription" {
  subscription_name = var.subscription_name
  billing_scope_id  = data.azurerm_billing_mca_account_scope.get_billing_scope.id
}

resource "azurerm_management_group_subscription_association" "add_subscription_to_mg" {
  management_group_id = var.management_group_id
  subscription_id     = azurerm_subscription.create_subscription.id
}