variable "Environment" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "Dev"
}

variable "Application" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "EKS Lab"
}

variable "domain_name" {
  type        = string
  description = "A domain name for which the certificate should be issued"
}

variable "validation_method" {
  type        = string
  description = "Method to use for validation, DNS or EMAIL"
  default     = "DNS"
}

# variable "route53_zone_name" {
#   type        = string
#   description = "Name for the Route53"
#   default     = ""
# }
