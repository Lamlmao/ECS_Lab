data "terraform_remote_state" "vpc_data" {
  backend = "s3"
  config = {
    bucket         = "remotebackendecs"
    dynamodb_table = "state-lock"
    key            = "sotatek/mytfstate/ecs_lab/networking/networking.tfstate"
    region         = "us-east-1"
  }
}

data "aws_acm_certificate" "issued" {
  domain   = "aws.hugotech.online"
  statuses = ["ISSUED"]
}

data "aws_route53_zone" "selected" {
  name         = "aws.hugotech.online"
}