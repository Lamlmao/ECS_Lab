data "aws_security_group" "redis_sg" {
  id = var.security_group_id
}