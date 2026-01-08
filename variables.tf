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

variable "bucket_logging" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources."
}

variable "bucket_1_name" {
  type        = string
  default     = ""
  description = "The name of the bucket which will be logged."
}

variable "bucket_2_name" {
  type        = string
  default     = ""
  description = "The name of the bucket which will store the logs."
}

variable "target_prefix" {
  type        = string
  default     = ""
  description = "The prefix for the log files."
}

variable "enable_bucket_object" {
  type        = bool
  default     = false
  description = "Set to false to prevent the module from creating any resources."
}

variable "key" {
  type        = string
  default     = null
  description = "The name of the object once it is in the bucket."
}

variable "content" {
  type        = string
  default     = null
  description = "text content to be stored in spaces."
}

variable "source_file" {
  type        = string
  default     = ""
  description = "path of the content to be stored in spaces."
}

variable "content_base64" {
  type        = string
  default     = null
  description = "Base64-encoded content for binary uploads"
}

variable "cache_control" {
  type        = string
  default     = null
  description = "Specifies caching behavior along the request/reply chain."
}

variable "content_disposition" {
  type        = string
  default     = null
  description = "Specifies presentational information for the object."
}

variable "content_encoding" {
  type        = string
  default     = null
  description = "Specifies what content encodings have been applied to the object and thus what decoding mechanisms must be applied to obtain the media-type referenced by the Content-Type header field."
}

variable "content_language" {
  type        = string
  default     = null
  description = "The language the content is in e.g. en-US or en-GB."
}

variable "content_type" {
  type        = string
  default     = null
  description = "A standard MIME type describing the format of the object data, e.g. application/octet-stream. All Valid MIME Types are valid for this input."
}

variable "website_redirect" {
  type        = string
  default     = null
  description = "Target URL to redirect requests to (if hosting a website)"
}

variable "metadata" {
  type        = map(string)
  default     = {}
  description = "A mapping of keys/values to provision metadata (will be automatically prefixed by x-amz-meta-, note that only lowercase label are currently supported by the AWS Go API)."
}

variable "etag" {
  type        = string
  default     = ""
  description = "Custom ETag to control updates"
}

variable "enabled_key" {
  type        = bool
  default     = false
  description = "key resource provided to space for security purpose, default set to false."
}

variable "key_name" {
  type        = string
  default     = ""
  description = "name of the access key of the space."
}

variable "grant" {
  type = list(object({
    bucket     = string
    permission = string
  }))
  default     = null
  description = "List of grant objects defining access for the Spaces key."
  ## Each grant requires:
  ##  - bucket: name of the bucket (empty string = all buckets)
  ##  - permission: fullaccess, readwrite, readonly"
}