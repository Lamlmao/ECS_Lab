resource "aws_route53_zone" "hosted_zone" {
  count    = var.create_route53_hosted_zone ? 1 : 0
  name     = var.domain_name
  tags = merge({
    Name = "${var.domain_name}-hosted-zone"
  }, local.tags)
}

