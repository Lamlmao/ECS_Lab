variable "repo_name" {
  type        = string
  description = "Name for the ECR Repo"
  default     = ""
}

variable "Environment" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "dev"
}

variable "Application" {
  type        = string
  description = "Environment to tag all resources created by this module"
  default     = "sotatek"
}