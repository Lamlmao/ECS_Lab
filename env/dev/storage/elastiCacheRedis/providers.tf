provider "aws" {
  alias   = "useast1"
  region  = "us-east-1"
}

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.30.0"
    }
  }
  backend "s3" {
    bucket         = "statestorage123"
    dynamodb_table = "state-lock"
    key            = "sotatek/mytfstate/ecs_lab/storage/elastiCacheRedis/elastiCacheRedis.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}
