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

variable "enable_cf" {
  type        = string
  description = "Option tp enable cloudfront or not"
  default     = "true"
}

variable "bucket_name" {
  type        = string
  description = "Name for the S3 Bucket"
  default     = ""
}

variable "aliases" {
  type        = list(string)
  description = "Extra CNAMEs (alternate domain names), if any, for this distribution."
  default     = [""]
}

variable "enable_aliases" {
  type        = bool
  description = "Option to enable extra CNAMES or not"
  default     = false
}

variable "price_class" {
  type        = string
  description = "Price class for this distribution. One of PriceClass_All, PriceClass_200, PriceClass_100."
  default     = "PriceClass_All"
}

variable "acm_certificate_arn" {
  type        = string
  description = "ARN for the Certificate"
  default     = ""
}

variable "default_root_object" {
  default = "index.html"
}

variable "object_key" {
  type        = string
  description = "Name of the Object in S3"
  default     = ""
}

variable "fe_path" {
  type        = any
  description = "Path to the html file in S3"
  default     = ""
}

variable "domain_name" {
  type        = string
  description = "The domain name for the website."
}

variable "hosted_zone_name" {
  type        = string
  description = "The Hosted Zone name"
}

variable "object_ownership" {
  type        = string
  description = "Object ownership"

}