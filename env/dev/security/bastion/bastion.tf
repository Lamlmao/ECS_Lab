module "bastion" {
  source                          = "../../../../module/bastion"
  for_each                        = var.bastion_configs
  application                     = each.value.application
  environment                     = each.value.environment
  subnet_id                       = each.value.public_subnets_id
  bastion_host_security_group_ids = [module.bastion_sg[each.value.sg].security_group[0].id]
  instance_type                   = each.value.instance_type
  bastion_iam_role                = aws_iam_instance_profile.bastion-host-instance-profile.name
}

module "bastion_sg" {
  source        = "../../../../module/security-group"
  for_each      = var.sg_configs
  name          = each.value.name
  vpc_id        = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].vpc_id
  description   = each.value.description
  ingress_rules = each.value.ingress
  Environment   = each.value.environment
  Application   = each.value.application
}

