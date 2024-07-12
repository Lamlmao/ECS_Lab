#Environments
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

#DynamoDB
variable "name" {
  description = "The name of your Dynamodb table"
  type        = string
}

variable "range_key" {
  description = "The identifier of your range key"
  type        = string
  default     = null
}

variable "hash_key" {
  description = "The identifier of your hash key"
  type        = string
  # default     = "LockID"
}

variable "attribute_name" {
  
}

variable "type" {
  description = "Type for attributes"
  type        = string
  # default     = "S"
}

#S3
variable "resource_uid" {
  type        = string
  description = "UID which will be prepended to resources created by this module"
}

variable "bucket_versioning" {
  type        = bool
  description = "Enable bucket versioning"
  default     = false
}

# variable "object_ownership" {
#   type        = string
#   description = "Object ownership"

# }
