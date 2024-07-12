module "s3_tfstate" {
  source            = "../../../../module/backend_State"
  for_each          = var.backend_configs
  Environment       = each.value.environment
  Application       = each.value.application
  resource_uid      = each.value.resource_uid
  name              = each.value.name
  hash_key          = each.value.hash_key
  attribute_name    = each.value.attribute_name
  type              = each.value.type
  bucket_versioning = each.value.bucket_versioning
}

