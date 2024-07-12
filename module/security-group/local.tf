locals {
  tags = {
    Environment = "${var.Environment}"
    Application = "${var.Application}"
  }
  managed_security_group_rules_enabled = var.enabled && var.managed_security_group_rules_enabled
}
