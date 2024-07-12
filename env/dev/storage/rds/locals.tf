locals {
  env    = "dev"
  region = "us-east-1"
}

locals {
  default_tag = {
    "env"          = "dev"
    "project code" = "sotatek"
    "managed_by"   = "terraform"
  }
}


