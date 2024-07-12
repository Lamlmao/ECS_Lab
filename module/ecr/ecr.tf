resource "aws_ecr_repository" "ecr" {
  force_delete = true
  name         = format("%s-ecr", local.header)
  image_scanning_configuration {
    scan_on_push = false
  }
  tags = local.tags
}
