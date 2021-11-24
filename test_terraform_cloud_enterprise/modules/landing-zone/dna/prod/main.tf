locals {
    # Get Environment nmae from folder name
    environment_name = basename(abspath(path.module))
}

module "prod" {
    source = "../../../project-core"
    billing_account_name  = var.billing_account_name
    billing_profile_name  = var.billing_profile_name
    invoice_section_name  = var.invoice_section_name
    business_unit_name    = var.business_unit_name
    management_group_name = var.management_group_name
    subscription_name     = "${var.business_unit_name}-${local.environment_name}"
}