locals {
  tags = {
    Environment = "${var.Environment}"
    Application = "${var.Application}"
  }
}