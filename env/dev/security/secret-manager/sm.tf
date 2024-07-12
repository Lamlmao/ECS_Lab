module "secret-managers" {
  source                  = "../../../../module/secret-manager"
  for_each                = var.secret-manager_configs
  name                    = each.value.secret_name
  recovery_window_in_days = each.value.recovery_window_in_days
  component               = each.key
}