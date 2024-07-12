resource "aws_security_group" "custom_sg" {
  count       = var.security_group_id == null ? 1 : 0
  name        = var.name
  vpc_id      = var.vpc_id
  description = var.description
  tags        = local.tags
  dynamic "ingress" {
    for_each = var.ingress_rules
    content {
      from_port   = ingress.value["from_port"]
      to_port     = ingress.value["to_port"]
      protocol    = ingress.value["protocol"]
      cidr_blocks = ingress.value["cidr_blocks"]
      description = ingress.value["description"]
    }

  }
  dynamic "egress" {
    for_each = var.egress_rules
    content {
      from_port   = egress.value["from_port"]
      to_port     = egress.value["to_port"]
      protocol    = egress.value["protocol"]
      cidr_blocks = egress.value["cidr_blocks"]
      description = egress.value["description"]
    }
  }
}

resource "aws_vpc_security_group_ingress_rule" "managed_ingress_security_groups" {
  count                        = local.managed_security_group_rules_enabled ? length(var.allowed_security_group_ids) : 0
  description                  = "Allow inbound traffic from existing Security Groups"
  ip_protocol                  = "-1"
  referenced_security_group_id = var.allowed_security_group_ids[count.index]
  security_group_id            = var.security_group_id == null ? aws_security_group.custom_sg[count.index].id : var.security_group_id
}

resource "aws_vpc_security_group_ingress_rule" "managed_ingress_cidr_blocks" {
  count             = local.managed_security_group_rules_enabled ? length(var.allowed_cidr_blocks) : 0
  description       = "Allow inbound traffic from CIDR blocks"
  ip_protocol       = "-1"
  cidr_ipv4         = var.allowed_cidr_blocks[count.index]
  security_group_id = var.security_group_id == null ? aws_security_group.custom_sg[count.index].id : var.security_group_id
}
