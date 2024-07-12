variable "Environment" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "dev"
}

variable "Application" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "Sotatek"
}

#Redis Replication Group

variable "family" {}
variable "failover_enabled" {}
variable "preferred_availability_zones" {}
variable "cluster_name" {}
variable "engine" {}
variable "node_type" {}
variable "engine_version" {}
variable "number_of_nodes" {}
variable "subnet_group_name" {}
variable "maintenance_window" {}
variable "vpc_id" {}
variable "tags" {}
variable "vpc_cidr_block" {}
variable "security_group_id" {}