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
  default = "jhjkhkjh"
}

variable "billing_profile_name" {
  default = "jhjkhkjh"  
}

variable "invoice_section_name" {
  default = "jhjkhkjh"  
}

variable "subscription_name" {
  default = "jhjkhkjh"  
}