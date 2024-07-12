resource "aws_elasticache_parameter_group" "redis" {
  name   = var.cluster_name
  family = var.family
}

resource "aws_cloudwatch_log_group" "redis" {
  name = "redis-${var.cluster_name}"
}

resource "aws_elasticache_replication_group" "redis" {
  automatic_failover_enabled  = var.failover_enabled
  apply_immediately           = true
  preferred_cache_cluster_azs = var.preferred_availability_zones
  replication_group_id        = var.cluster_name
  description                 = var.cluster_name
  engine                      = var.engine
  node_type                   = var.node_type
  engine_version              = var.engine_version
  port                        = 6379
  num_cache_clusters          = var.number_of_nodes
  parameter_group_name        = aws_elasticache_parameter_group.redis.name
  subnet_group_name           = var.subnet_group_name
  security_group_ids          = [data.aws_security_group.redis_sg.id]
  maintenance_window          = var.maintenance_window
  auto_minor_version_upgrade  = false
  log_delivery_configuration {
    destination      = aws_cloudwatch_log_group.redis.name
    destination_type = "cloudwatch-logs"
    log_format       = "text"
    log_type         = "slow-log"
  }
  lifecycle {
    ignore_changes = [security_group_names, auth_token_update_strategy]
  }
}
