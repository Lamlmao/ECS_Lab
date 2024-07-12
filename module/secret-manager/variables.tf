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

variable "component" {
  type        = string
  description = "EXtra component name"
  default     = ""
}

variable "name" {
  type        = string
  description = "The secret manager name"
}

variable "recovery_window_in_days" {
  type        = number
  description = "Number of days that AWS Secrets Manager waits before it can delete the secret"
  default     = 30
}

variable "secrets" {
  type        = any
  description = "A map containing secrets"
  default     = {}
}

variable "create_iam_policy" {
  type    = bool
  default = true
}
