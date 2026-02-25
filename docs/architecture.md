# terraform-digitalocean-spaces — Architecture

## Overview

This module provisions DigitalOcean Spaces buckets and related resources. Spaces is DigitalOcean's S3-compatible object storage service. The module exposes bucket creation, ACL control, CORS configuration, lifecycle rules, bucket policies, access logging, bucket objects, and Spaces access keys through a single, composable interface.

---

## What Spaces Is

DigitalOcean Spaces is an S3-compatible object storage service. Buckets are accessed over HTTPS using the endpoint format:

```
https://<bucket-name>.<region>.digitaloceanspaces.com
```

Because the API is S3-compatible, any tool or library that supports AWS S3 (Terraform S3 backend, AWS CLI, s3cmd, boto3) works with Spaces after supplying the correct endpoint and credentials.

---

## ACL Options

The `acl` variable controls the canned access control policy applied at bucket creation.

| Value          | Description                                               |
|----------------|-----------------------------------------------------------|
| `private`      | Only the bucket owner can read and write objects          |
| `public-read`  | Anyone on the internet can read objects; only owner writes|

Use `private` for all buckets that are not intentionally serving public content. Set bucket policies to enforce additional access restrictions beyond the canned ACL.

The same `acl` value is applied to bucket objects when `enable_bucket_object = true`.

---

## Bucket Objects

Set `enable_bucket_object = true` to upload a single object to the bucket at apply time. Provide the object key and content through one of three mutually exclusive inputs:

| Input            | Use case                                        |
|------------------|-------------------------------------------------|
| `content`        | Inline text content (e.g. HTML, JSON)           |
| `source_file`    | Path to a local file                            |
| `content_base64` | Base64-encoded binary content                   |

Additional object metadata inputs: `content_type`, `content_encoding`, `content_disposition`, `content_language`, `cache_control`, `website_redirect`, `metadata`, and `etag`.

---

## CORS Configuration

Pass a list of CORS rule objects via `cors_rule` to configure cross-origin resource sharing on the bucket:

```hcl
cors_rule = [
  {
    allowed_headers = ["*"]
    allowed_methods = ["GET", "PUT", "POST"]
    allowed_origins = ["https://app.example.com"]
    expose_headers  = ["ETag"]
    max_age_seconds = 3000
  }
]
```

CORS rules are required when browser-based applications read from or write to the bucket directly using JavaScript fetch or XMLHttpRequest.

---

## Lifecycle Rules

Lifecycle rules automate the expiration of objects and clean up of incomplete multipart uploads:

```hcl
lifecycle_rule = [
  {
    enabled                                = true
    abort_incomplete_multipart_upload_days = 7
    noncurrent_version_expiration_days     = 30
  }
]

expiration = [
  {
    days                         = 90
    expired_object_delete_marker = true
  }
]
```

Versioning is enabled by default (`versioning = true`). When versioning is enabled, `noncurrent_version_expiration_days` controls how long previous object versions are retained.

---

## Bucket Policy

Pass an IAM-style JSON policy string via `policy` to enforce access restrictions such as IP-based allow/deny rules or mandatory TLS:

```hcl
policy = jsonencode({
  Version = "2012-10-17"
  Statement = [
    {
      Sid       = "DenyHTTP"
      Effect    = "Deny"
      Principal = "*"
      Action    = "s3:*"
      Resource  = ["arn:aws:s3:::my-bucket", "arn:aws:s3:::my-bucket/*"]
      Condition = {
        Bool = { "aws:SecureTransport" = "false" }
      }
    }
  ]
})
```

---

## Spaces Access Keys

Set `enabled_key = true` and supply `key_name` and `grant` to create a scoped Spaces access key:

```hcl
enabled_key = true
key_name    = "ci-key"
grant = [
  { bucket = "my-bucket", permission = "readwrite" },
  { bucket = "",           permission = "readonly"  }
]
```

Valid `permission` values: `fullaccess`, `readwrite`, `readonly`. An empty string for `bucket` applies the permission to all buckets in the account. The generated `access_key` and `secret_key` are available via the `access_key_id` and `secret_key_id` outputs (the latter is sensitive).

---

## Bucket Access Logging

Set `bucket_logging = true` to enable server access logging. Provide the source bucket name in `bucket_1_name` and the logging target bucket in `bucket_2_name`. Use `target_prefix` to namespace log files within the target bucket.

The logging target bucket must exist before enabling logging. Create it with a separate module invocation.

---

## Integration with CDN

The `bucket_domain_name` output provides the Spaces bucket domain. This value can be passed to a CDN module (e.g., `terraform-digitalocean-cdn`) as the origin endpoint to serve bucket content through DigitalOcean's global CDN edge network. The `urn` output can be used to assign the bucket to a DigitalOcean project.

---

## Using Spaces for Terraform Remote State

Spaces can store Terraform or OpenTofu remote state using the S3 backend. Create a dedicated private bucket and configure the backend as follows:

```hcl
terraform {
  backend "s3" {
    endpoint = "https://nyc3.digitaloceanspaces.com"
    region   = "us-east-1"
    bucket   = "my-tfstate-bucket"
    key      = "project/terraform.tfstate"

    skip_credentials_validation = true
    skip_metadata_api_check     = true
    skip_region_validation      = true
    force_path_style            = true
  }
}
```

Set the `SPACES_ACCESS_KEY_ID` and `SPACES_SECRET_ACCESS_KEY` environment variables (mapped to `AWS_ACCESS_KEY_ID` and `AWS_SECRET_ACCESS_KEY` by the S3 backend). Do not use the same bucket for remote state and application data.

---

## Operational Checklist

- Always set `acl = "private"` unless the bucket intentionally serves public content.
- Enable versioning (`versioning = true`, the default) for buckets that store critical or user-generated data.
- Set `force_destroy = false` (the default) in production to prevent accidental data loss during `terraform destroy`.
- Configure lifecycle rules to expire old object versions and abort incomplete multipart uploads.
- Use `bucket_logging` to capture access logs for audit and security analysis.
- Restrict bucket access with `policy` for IP allowlisting or mandatory TLS enforcement.
- Use scoped Spaces access keys (`enabled_key = true`) with minimum required permissions rather than account-level credentials.
- Store `secret_key_id` output values in a secrets manager; they are marked sensitive.
- Use a dedicated bucket (separate from application buckets) for Terraform remote state.
- Export `SPACES_ACCESS_KEY_ID` and `SPACES_SECRET_ACCESS_KEY` in your CI/CD environment rather than embedding credentials in configuration files.
