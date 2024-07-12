module "postgre_master" {
  source  = "terraform-aws-modules/rds/aws"
  version = "6.6.0"

  for_each   = var.rds_configs
  identifier = "${each.value.name}-master"

  engine               = each.value.engine
  engine_version       = each.value.engine_version
  family               = each.value.family
  major_engine_version = each.value.major_engine_version
  instance_class       = each.value.instance_class

  allocated_storage     = each.value.allocated_storage
  max_allocated_storage = each.value.max_allocated_storage

  db_name  = each.value.db_name
  username = each.value.username
  port     = each.value.port
  multi_az = each.value.multi_az

  manage_master_user_password_rotation              = each.value.manage_master_user_password_rotation
  master_user_password_rotate_immediately           = each.value.master_user_password_rotate_immediately
  master_user_password_rotation_schedule_expression = each.value.master_user_password_rotation_schedule_expression

  db_subnet_group_name   = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].database_subnet_group_name
  vpc_security_group_ids =[module.rds_sg[each.value.sg].security_group[0].id]

  maintenance_window              = each.value.maintenance_window
  backup_window                   = each.value.backup_window
  enabled_cloudwatch_logs_exports = ["postgresql", "upgrade"]
  create_cloudwatch_log_group     = true

  backup_retention_period = each.value.backup_retention_period
  skip_final_snapshot     = each.value.skip_final_snapshot
  deletion_protection     = each.value.deletion_protection
  apply_immediately       = true
}

module "rds_sg" {
  source        = "../../../../module/security-group"
  for_each      = var.sg_configs
  name          = each.value.name
  vpc_id        = data.terraform_remote_state.vpc_data.outputs.vpc[each.value.vpc_name].vpc_id
  description   = each.value.description
  ingress_rules = each.value.ingress
  Environment   = each.value.environment
  Application   = each.value.application
}
