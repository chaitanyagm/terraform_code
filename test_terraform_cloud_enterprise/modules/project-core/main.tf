# module "networking" {
#   source                = ".//networking"
# }

module "subscription" {
    source                = ".//subscription"
    billing_account_name  = var.billing_account_name
    billing_profile_name  = var.billing_profile_name
    invoice_section_name  = var.invoice_section_name
    business_unit_name    = var.business_unit_name
    management_group_name = var.management_group_name
    subscription_name     = var.subscription_name
}

# module "logging" {
#   source                = ".//logging"
# }