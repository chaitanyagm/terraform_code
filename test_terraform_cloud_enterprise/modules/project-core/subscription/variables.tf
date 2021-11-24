variable "common_tags" {
  type          = map(string)
  description   = "value"
  default = {}
#   validation {
#     condition     = var.common_tags == "" ? false : true
#     error_message = "Tags cannot be null or empty"
#   }
}

variable "billing_account_name" {
}

variable "billing_profile_name" {
}

variable "invoice_section_name" {
}

variable "business_unit_name" {
}

variable "management_group_id" {
}

variable "subscription_name" {
}