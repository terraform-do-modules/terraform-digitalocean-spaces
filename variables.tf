#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "terraform-do-modules"
  description = "ManagedBy, eg 'terraform-do-modules' or 'hello@clouddrove.com'"
}

variable "region" {
  type        = string
  default     = "blr1"
  description = "The region to create spaces."
}

#Module      : spaces
#Description : Provides a bucket resource for Spaces, DigitalOcean's object storage product.

variable "acl" {
  type        = string
  default     = null
  description = "Canned ACL applied on bucket creation (private or public-read)."
}

variable "versioning" {
  type        = bool
  default     = true
  description = "(Optional) A state of versioning (documented below)."
}

variable "force_destroy" {
  type        = bool
  default     = false
  description = "Unless true, the bucket will only be destroyed if empty (Defaults to false)."
}

variable "cors_rule" {
  type = list(object({
    allowed_headers = list(string)
    allowed_methods = list(string)
    allowed_origins = list(string)
    expose_headers  = list(string)
    max_age_seconds = number
  }))
  default     = null
  description = "CORS Configuration specification for this bucket"
}

variable "lifecycle_rule" {
  type        = list(any)
  default     = []
  description = "A configuration of object lifecycle management (documented below)."
}

variable "expiration" {
  type        = list(any)
  default     = []
  description = "Specifies a time period after which applicable objects expire (documented below)."
}

variable "policy" {
  type        = any
  default     = null
  description = "The text of the policy."
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Whether to create the resources. Set to `false` to prevent the module from creating any resources."
}
