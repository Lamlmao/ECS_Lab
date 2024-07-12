variable "Environment" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "Automation"
}

variable "Application" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "S3 Static Website"
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "create_route53_hosted_zone" {
  type = bool
  description = "Decide to create Route53 or not"
  default = false
}
