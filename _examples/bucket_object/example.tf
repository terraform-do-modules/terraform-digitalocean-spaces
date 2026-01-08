provider "digitalocean" {
}

##------------------------------------------------
## spaces module call
##------------------------------------------------
module "spaces" {
  source        = "./../../"
  name          = "spaces"
  environment   = "test"
  acl           = "private"
  force_destroy = false
  region        = "nyc3"

  enable_bucket_object = true
  key                  = "index.html"
  content              = "<html><body><p>This page is empty.</p></body></html>"
  content_type         = "text/html"
}