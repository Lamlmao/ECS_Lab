module "ecrs" {
  source      = "../../../../module/ecr"
  for_each    = var.ecr_configs
  repo_name   = each.value.repo_name
  Environment = each.value.environment
  Application = each.value.application
}
