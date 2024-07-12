data "terraform_remote_state" "vpc_data" {
  backend = "s3"
  config = {
    bucket         = "statestorage123"
    dynamodb_table = "state-lock"
    key            = "sotatek/mytfstate/ecs_lab/networking/networking.tfstate"
    region         = "us-east-1"
  }
}
