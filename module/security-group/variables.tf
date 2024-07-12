#Tagging
variable "Environment" {
  description = "A mapping of tags to assign to the resource."
  type        = string
  default     = ""
}

variable "Application" {
  description = "A mapping of tags to assign to the resource."
  type        = string
  default     = ""
}

variable "enabled" {
  description = "Decide to Enabled SG or not"
  type        = bool
  default     = false
}

#Security Groups
variable "vpc_id" {
  description = "The ID of the VPC where the security group will take place"
  type        = string
}

variable "name" {
  description = "The name of your security group"
  type        = string
}

variable "description" {
  description = "Purpose for the Security Group"
  type        = string
}

variable "ingress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = [{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow SSH connection"
  }]
}

variable "egress_rules" {
  type = list(object({
    from_port   = number
    to_port     = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))

  default = [{
    from_port   = 0
    to_port     = 0
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow All connection"
  }]
}

variable "managed_security_group_rules_enabled" {
  type        = bool
  description = "Flag to enable/disable the ingress and egress rules for the EKS managed Security Group"
  default     = true
}

variable "allowed_security_group_ids" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IDs of Security Groups to allow access to the cluster.
    EOT
}

variable "allowed_cidr_blocks" {
  type        = list(string)
  default     = []
  description = <<-EOT
    A list of IPv4 CIDRs to allow access to the cluster.
    The length of this list must be known at "plan" time.
    EOT
}

variable "security_group_id" {
  default = null 
}