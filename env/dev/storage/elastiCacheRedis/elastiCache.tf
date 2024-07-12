module "elasticache" {
  source                       = "../../../../module/elasticCache-redis"
  for_each                     = var.elasticache_configs
  cluster_name                 = each.value.cluster_name
  family                       = each.value.family
  engine                       = each.value.engine
  node_type                    = each.value.node_type
  engine_version               = each.value.engine_version
  subnet_group_name            = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].elasticache_subnet_group_name
  preferred_availability_zones = each.value.availability_zone
  number_of_nodes              = each.value.number_of_nodes
  maintenance_window           = each.value.maintenance_window
  failover_enabled             = each.value.failover_enabled
  vpc_id                       = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].vpc_id
  vpc_cidr_block               = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].vpc_cidr_block
  security_group_id            = module.redis_sg[each.value.sg].security_group[0].id
  tags                         = local.default_tag
}

module "redis_sg" {
  source        = "../../../../module/security-group"
  for_each      = var.sg_configs
  name          = each.value.name
  vpc_id        = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].vpc_id
  description   = each.value.description
  ingress_rules = each.value.ingress
  egress_rules  = each.value.egress
  Environment   = each.value.environment
  Application   = each.value.application
}
