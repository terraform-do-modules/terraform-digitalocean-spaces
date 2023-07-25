provider "digitalocean" {
  spaces_access_id  = "xxxxxxxxxxxxxxxxxxxx"
  spaces_secret_key = "xxxxxxxxxxxxxxxxxxxx"
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
