resource "aws_codebuild_project" "codebuild" {
  name         = "${var.env}-${var.project}-${var.gitRepo}"
  service_role = var.codebuildRoleArn

  artifacts {
    type = "CODEPIPELINE"
  }

  environment {
    compute_type    = var.codebuild_image
    image           = var.codebuild_compute_type
    privileged_mode = true
    type            = "LINUX_CONTAINER"
    environment_variable {
      name  = "ENV"
      value = "${var.env}"
    }
    environment_variable {
      name  = "PROJECT"
      value = "${var.project}"
    }
    environment_variable {
      name  = "SERVICE"
      value = "${var.gitRepo}"
    }
    environment_variable {
      name  = "ACCOUNT_ID"
      value = "${data.aws_caller_identity.current.account_id}"
    }
  }
  source {
    type      = "CODEPIPELINE"
    buildspec = templatefile("${var.buildspec_file}", {})
  }
}

resource "aws_codepipeline" "codepipeline_fe" {
  name     = "${var.env}-${var.project}-${var.gitRepo}"
  role_arn = var.codepipelineRoleArn

  artifact_store {
    location = var.bucketName
    type     = "S3"
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "S3"
      version          = "1"
      output_artifacts = ["Source_Artifacts"]

      configuration = {
        S3Bucket    = var.bucketName
        S3ObjectKey = format("%s/%s/%s/metadata.zip", var.organization, var.gitRepo, var.gitBranch)
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["Source_Artifacts"]
      output_artifacts = ["Build_Artifacts"]
      version          = "1"

      configuration = {
        ProjectName = aws_codebuild_project.codebuild.name
      }
    }
  }
}

## Wire the CodePipeline webhook into a GitHub repository.
resource "github_repository_webhook" "bar" {
  repository = var.gitRepo

  configuration {
    url          = var.lambda_endpoint
    content_type = "json"
    insecure_ssl = false
    secret       = var.lambda_secret
  }

  events = ["push"]
}