# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "urn" {
  value       = join("", digitalocean_spaces_bucket.spaces[*].urn)
  description = " The uniform resource name for the bucket."
}

output "name" {
  value       = join("", digitalocean_spaces_bucket.spaces[*].name)
  description = "The name of the bucket."
}

output "bucket_domain_name" {
  value       = join("", digitalocean_spaces_bucket.spaces[*].bucket_domain_name)
  description = "The domain_name of the bucket."
}

output "object_version_id" {
  value       = join("", digitalocean_spaces_bucket_object.index[*].version_id)
  description = "A unique version ID value for the object, if bucket versioning is enabled."
}

output "key_name" {
  value       = join("", digitalocean_spaces_key.foobar[*].name)
  description = "The name of the key associated with the spaces."
}

output "key_grant" {
  value = {
    for key in digitalocean_spaces_key.foobar :
    key.name => {
      for g in key.grant :
      g.bucket => g.permission
    }
  }
}

output "access_key_id" {
  value       = join("", digitalocean_spaces_key.foobar[*].access_key)
  description = "The access key ID of the key associated with the spaces."
}

output "secret_key_id" {
  value       = join("", digitalocean_spaces_key.foobar[*].secret_key)
  description = "The access key secret of the key associated with the spaces."
}

output "key_created_at" {
  value       = join("", digitalocean_spaces_key.foobar[*].created_at)
  description = "The creation time of the key associated with the spaces."
}