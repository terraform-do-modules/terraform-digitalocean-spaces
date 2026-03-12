# Terraform version
terraform {
  required_version = ">= 2.79.0"
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = ">= 2.79.0"
    }
  }
}
