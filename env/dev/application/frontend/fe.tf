module "fe" {
  source              = "../../../../module/s3-cloudfront"
  for_each            = var.fe_configs
  Application         = each.value.application
  Environment         = each.value.environment
  enable_cf           = each.value.enable_cf
  bucket_name         = each.value.bucket_name
  enable_aliases      = each.value.enable_aliases
  aliases             = each.value.enable_aliases ? each.value.aliases : []
  price_class         = each.value.price_class
  acm_certificate_arn = data.aws_acm_certificate.issued.arn
  default_root_object = each.value.default_root_object
  object_key          = each.value.object_key
  fe_path             = each.value.fe_path
  domain_name         = each.value.domain_name
  hosted_zone_name    = each.value.hosted_zone_name
  object_ownership    = each.value.object_ownership
}

