
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.1"
  for_each = {
    for k, v in var.vpc_configs : "${local.env}-${local.region}-${v.name_prefix}" => v
  }
  name = each.key
  cidr = each.value.cidr

  azs                 = each.value.azs
  private_subnets     = each.value.private_subnets
  public_subnets      = each.value.public_subnets
  database_subnets    = each.value.database_subnets
  elasticache_subnets = each.value.elasticache_subnets
  public_subnet_tags  = each.value.public_subnet_tags
  private_subnet_tags = merge(each.value.private_subnet_tags)

  enable_nat_gateway     = each.value.enable_nat_gateway
  single_nat_gateway     = each.value.single_nat_gateway
  one_nat_gateway_per_az = each.value.one_nat_gateway_per_az

  enable_dns_hostnames = each.value.enable_dns_hostnames
  enable_dns_support   = each.value.enable_dns_support

  tags = merge(local.default_tag, each.value.tags)
}

module "route53" {
  source                     = "../../../module/route53"
  for_each                   = var.route53_configs
  create_route53_hosted_zone = each.value.create_route53_hosted_zone
  domain_name                = each.value.domain_name
  Environment                = each.value.environment
  Application                = each.value.application
}
