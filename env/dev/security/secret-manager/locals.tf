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

locals {
  security_group_name = "staging-rds-mysql-sg"
  security_group_tag = {
    "associate_resource" = "rds"
  }
}