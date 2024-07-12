locals {
  tags = {
    Environment = "${var.Environment}"
    Application = "${var.Application}"
  }
  header = "${var.Application}-${var.Environment}"
}
