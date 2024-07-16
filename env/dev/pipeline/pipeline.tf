# CODE PIPELINE
module "pipelinebase" {
  source  = "../../../module/basic_pipeline"
  project = var.project
  env     = var.env
  tags    = local.default_tag
}

module "codepipeline_fe" {
  source = "../../../module/pipeline-fe"

  project = var.project
  env     = var.env

  service_name = "${var.env}-${var.project}-${var.parameta-egg3-fe-repo.name}"

  codebuild_image        = var.codebuild_image
  codebuild_compute_type = var.codebuild_compute_type

  codebuild_buildspec = var.codebuild_buildspec
  bucketName          = module.pipelinebase.s3_bucket
  codepipelineRoleArn = module.pipelinebase.codepipeline_role_arn

  gitBranch    = var.sotatek-ecs-fe-repo.branch
  gitRepo      = var.sotatek-ecs-fe-repo.name
  organization = var.sotatek-ecs-fe-repo.organization

  codebuildRoleArn  = module.basic_pipeline.codebuild_role_arn
  codedeployRoleArn = module.basic_pipeline.codedeploy_role_arn
  lambda_endpoint   = module.basic_pipeline.lambda_endpoint

  lambda_secret  = module.basic_pipeline.secret_key
  buildspec_file = "../../../buildspec/ecs_lab_fe.tpl"
}

module "codepipeline_be" {
  source = "../../../module/pipeline-be"

  project = var.project
  env     = var.env

  codebuild_image        = var.codebuild_image
  codebuild_compute_type = var.codebuild_compute_type

  codebuild_buildspec = var.codebuild_buildspec
  bucketName          = module.basic_pipeline.s3_bucket
  codepipelineRoleArn = module.basic_pipeline.codepipeline_role_arn

  gitBranch    = var.sotatek-ecs-be-repo.branch
  gitRepo      = var.sotatek-ecs-be-repo.name
  organization = var.sotatek-ecs-be-repo.organization

  codebuildRoleArn  = module.basic_pipeline.codebuild_role_arn
  codedeployRoleArn = module.basic_pipeline.codedeploy_role_arn
  lambda_endpoint   = module.basic_pipeline.lambda_endpoint

  lambda_secret  = module.pipelinebase.secret_key
  buildspec_file = "../../../buildspec/ecs_lab_be.tpl"
}