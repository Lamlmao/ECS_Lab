# variable "OAuthToken" {}
variable "organization" {}
variable "gitRepo" {}
variable "gitBranch" {}
variable "codepipelineRoleArn" {}
variable "bucketName" {}

variable "project" {
  type        = string
  description = "Project name"
}

variable "env" {
  type        = string
  description = "Environment name"
}

variable "codebuildRoleArn" {}
variable "codedeployRoleArn" {}
variable "codebuild_image" {}
variable "codebuild_compute_type" {}
# variable "github_repos" {}
variable "codebuild_buildspec" {}
variable "lambda_endpoint" {}
variable "lambda_secret" {}
variable "buildspec_file" {}