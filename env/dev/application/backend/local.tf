locals {
  env          = "dev"
  region       = "us-east-1"
  project_code = "sotatek"
}

locals {
  default_tag = {
    "env"          = "dev"
    "project code" = "sotatek"
  }
}

locals {
  services = merge({
    "lab-ecs-service" = ""
    },
    {
      for key, value in var.configs :
      key => key
    }
  )
}

