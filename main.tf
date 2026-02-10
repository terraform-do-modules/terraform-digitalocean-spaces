##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "terraform-do-modules/labels/digitalocean"
  version     = "1.0.3"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

##-----------------------------------------------------------------------------
##Description : Provides a bucket resource for Spaces, DigitalOcean's object storage product.
##-----------------------------------------------------------------------------
resource "digitalocean_spaces_bucket" "spaces" {
  count         = var.enabled ? 1 : 0
  name          = module.labels.id
  region        = var.region
  acl           = var.acl
  force_destroy = var.force_destroy

  dynamic "lifecycle_rule" {
    for_each = var.lifecycle_rule
    content {
      id                                     = lookup(lifecycle_rule.value, "id", null)
      enabled                                = lookup(lifecycle_rule.value, "enabled", false)
      prefix                                 = lookup(lifecycle_rule.value, "prefix", null)
      abort_incomplete_multipart_upload_days = lookup(lifecycle_rule.value, "abort_incomplete_multipart_upload_days", null)
      dynamic "expiration" {
        for_each = var.expiration
        content {
          date                         = lookup(expiration.value, "date", null)
          days                         = lookup(expiration.value, "days", null)
          expired_object_delete_marker = lookup(expiration.value, "expired_object_delete_marker", false)
        }
      }
      noncurrent_version_expiration {
        days = lookup(lifecycle_rule.value, "noncurrent_version_expiration_days", null)
      }
    }
  }
  versioning {
    enabled = var.versioning
  }
}

##-----------------------------------------------------------------------------
#Description : The digitalocean_spaces_bucket_policy resource allows Terraform to attach bucket policy to Spaces.
##-----------------------------------------------------------------------------
resource "digitalocean_spaces_bucket_policy" "foobar" {
  count  = var.enabled && var.policy != null ? 1 : 0
  region = join("", digitalocean_spaces_bucket.spaces[*].region)
  bucket = join("", digitalocean_spaces_bucket.spaces[*].name)
  policy = var.policy
}

##------------------------------------------------------------------------------
#Provides a CORS configuration resource for Spaces, DigitalOcean's object storage product.
##------------------------------------------------------------------------------

resource "digitalocean_spaces_bucket_cors_configuration" "test" {
  count  = var.enabled && var.cors_rule != null ? 1 : 0
  bucket = digitalocean_spaces_bucket.spaces[count.index].id
  region = var.region

  dynamic "cors_rule" {
    for_each = var.cors_rule == null ? [] : var.cors_rule
    content {
      allowed_headers = cors_rule.value.allowed_headers
      allowed_methods = cors_rule.value.allowed_methods
      allowed_origins = cors_rule.value.allowed_origins
      max_age_seconds = cors_rule.value.max_age_seconds
    }
  }
}

##------------------------------------------------------------------------------
#Provides a bucket logging resource for Spaces, DigitalOcean's object storage product.
##------------------------------------------------------------------------------

resource "digitalocean_spaces_bucket_logging" "example" {
  count         = var.enabled && var.bucket_logging ? 1 : 0
  region        = var.region
  bucket        = var.bucket_1_name
  target_bucket = var.bucket_2_name
  target_prefix = var.target_prefix
}

##--------------------------------------------------------------------------------
#Provides a bucket object resource for Spaces, DigitalOcean's object storage product.
##--------------------------------------------------------------------------------

resource "digitalocean_spaces_bucket_object" "index" {
  count  = var.enabled && var.enable_bucket_object ? 1 : 0
  bucket = digitalocean_spaces_bucket.spaces[count.index].id
  region = var.region
  key    = var.key

  # Provide either content or source or content_base64(for Small Content)
  content             = var.content != "" ? var.content : null
  source              = var.source_file != "" ? var.source_file : null
  content_base64      = var.content_base64
  acl                 = var.acl
  cache_control       = var.cache_control
  content_disposition = var.content_disposition
  content_encoding    = var.content_encoding
  content_language    = var.content_language
  content_type        = var.content_type
  website_redirect    = var.website_redirect
  metadata            = var.metadata
  etag                = var.etag
  force_destroy       = var.force_destroy
}

##---------------------------------------------------------------------------------
#Provides a key resource for Spaces, DigitalOcean's object storage product.
##---------------------------------------------------------------------------------

resource "digitalocean_spaces_key" "foobar" {
  count = var.enabled && var.enabled_key ? 1 : 0
  name  = var.key_name
  dynamic "grant" {
    for_each = var.grant
    content {
      bucket     = grant.value.bucket
      permission = grant.value.permission
    }
  }
}