# terraform-digitalocean-spaces — Inputs and Outputs

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name (e.g. `app` or `cluster`). | `string` | `""` | no |
| `environment` | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| `label_order` | Label order, e.g. `name`, `application`. | `list(any)` | `["name", "environment"]` | no |
| `managedby` | ManagedBy, e.g. `terraform-do-modules` or `hello@clouddrove.com`. | `string` | `"terraform-do-modules"` | no |
| `enabled` | Whether to create the resources. Set to `false` to prevent the module from creating any resources. | `bool` | `true` | no |
| `region` | The DigitalOcean region in which to create the Spaces bucket. | `string` | `"blr1"` | no |
| `acl` | Canned ACL applied on bucket creation: `private` or `public-read`. | `string` | `null` | no |
| `versioning` | Enable object versioning on the bucket. | `bool` | `true` | no |
| `force_destroy` | When `true`, the bucket can be destroyed even if it contains objects. | `bool` | `false` | no |
| `cors_rule` | CORS configuration for the bucket. Each rule specifies `allowed_headers`, `allowed_methods`, `allowed_origins`, `expose_headers`, and `max_age_seconds`. | `list(object({allowed_headers=list(string), allowed_methods=list(string), allowed_origins=list(string), expose_headers=list(string), max_age_seconds=number}))` | `null` | no |
| `lifecycle_rule` | Object lifecycle management configuration. Supports `id`, `enabled`, `prefix`, `abort_incomplete_multipart_upload_days`, and `noncurrent_version_expiration_days`. | `list(any)` | `[]` | no |
| `expiration` | Specifies expiration rules for objects. Supports `date`, `days`, and `expired_object_delete_marker`. | `list(any)` | `[]` | no |
| `policy` | Bucket policy JSON string (IAM-style S3 policy). | `any` | `null` | no |
| `bucket_logging` | Enable server access logging for the bucket. | `bool` | `false` | no |
| `bucket_1_name` | Name of the bucket to enable logging on (source). | `string` | `""` | no |
| `bucket_2_name` | Name of the bucket to store log files in (target). | `string` | `""` | no |
| `target_prefix` | Prefix for log files stored in the target bucket. | `string` | `""` | no |
| `enable_bucket_object` | When `true`, upload a single object to the bucket. | `bool` | `false` | no |
| `key` | The key (name) of the object once it is in the bucket. | `string` | `null` | no |
| `content` | Inline text content to store as the bucket object. | `string` | `null` | no |
| `source_file` | Local file path of the content to upload as the bucket object. | `string` | `""` | no |
| `content_base64` | Base64-encoded binary content for the bucket object. | `string` | `null` | no |
| `cache_control` | Specifies caching behavior along the request/reply chain. | `string` | `null` | no |
| `content_disposition` | Specifies presentational information for the object. | `string` | `null` | no |
| `content_encoding` | Specifies what content encodings have been applied to the object. | `string` | `null` | no |
| `content_language` | The language of the content (e.g. `en-US`). | `string` | `null` | no |
| `content_type` | MIME type describing the format of the object data (e.g. `text/html`). | `string` | `null` | no |
| `website_redirect` | Target URL to redirect requests to when hosting a static website. | `string` | `null` | no |
| `metadata` | Map of keys/values to provision as object metadata (prefixed with `x-amz-meta-`). | `map(string)` | `{}` | no |
| `etag` | Custom ETag value to control object update detection. | `string` | `""` | no |
| `enabled_key` | When `true`, create a Spaces access key. | `bool` | `false` | no |
| `key_name` | Name of the Spaces access key to create. | `string` | `""` | no |
| `grant` | List of grant objects defining access for the Spaces key. Each object requires `bucket` (bucket name or `""` for all) and `permission` (`fullaccess`, `readwrite`, or `readonly`). | `list(object({bucket=string, permission=string}))` | `null` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| `urn` | The uniform resource name of the Spaces bucket. |
| `name` | The name of the Spaces bucket. |
| `bucket_domain_name` | The domain name of the Spaces bucket (e.g. `<name>.<region>.digitaloceanspaces.com`). |
| `object_version_id` | A unique version ID for the uploaded bucket object, if versioning is enabled. |
| `key_name` | The name of the Spaces access key associated with the bucket. |
| `key_grant` | Map of key name to a map of bucket names to their granted permissions. |
| `access_key_id` | The access key ID of the Spaces key. |
| `secret_key_id` | The secret access key of the Spaces key. *(sensitive)* |
| `key_created_at` | The creation timestamp of the Spaces access key. |
