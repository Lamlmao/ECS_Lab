data "aws_acm_certificate" "issued" {
  domain   = "aws.hugotech.online"
  statuses = ["ISSUED"]
}