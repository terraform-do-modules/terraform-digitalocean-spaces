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

}
