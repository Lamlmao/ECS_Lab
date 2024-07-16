resource "aws_iam_role" "codedeploy_role" {
  name = "${var.env}-${var.project}-codedeploy-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Sid": "",
      "Effect": "Allow",
      "Principal": {
        "Service": "codedeploy.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "AWSCodeDeployRole" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSCodeDeployRole"
  role       = aws_iam_role.codedeploy_role.name
}

resource "aws_iam_role" "pipeline_role" {
  name = "${var.env}-${var.project}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF

  tags = var.tags
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  role = aws_iam_role.pipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObjectAcl",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.bucket_artifact.arn}",
        "${aws_s3_bucket.bucket_artifact.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codedeploy:*"
      ],
      "Resource": "*"
    }

  ]
}
EOF

}
resource "aws_iam_role_policy_attachment" "codepipeline-attach" {
  role       = aws_iam_role.pipeline_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonECS_FullAccess"
}
resource "aws_iam_role" "codebuild_role" {
  name = "${var.env}-${var.project}-codebuild-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "codebuild.amazonaws.com"
        }
      }
    ]
  })

  tags = var.tags
}
resource "aws_iam_role_policy" "s3_policy_cicd" {
  role = aws_iam_role.codebuild_role.name

  policy = jsonencode(
    {
      Version = "2012-10-17",
      Statement = [
        {
          Effect = "Allow",
          Resource = [
            "*"
          ],
          Action = [
            "logs:*",
            "ssm:*"
          ]
        },
        {
          Effect = "Allow",
          Resource = [
            "*"
          ],
          Action = [
            "ecr:GetDownloadUrlForLayer",
            "ecr:BatchGetImage",
            "ecr:CompleteLayerUpload",
            "ecr:UploadLayerPart",
            "ecr:InitiateLayerUpload",
            "ecr:BatchCheckLayerAvailability",
            "ecr:GetAuthorizationToken",
            "ecr:PutImage"
          ]
        },
        {
          Effect = "Allow",
          Resource = [
            "*"
          ],
          Action = [
            "ssm:DescribeParameters",
            "ssm:GetParameter"
          ]
        },
        {
          Effect = "Allow",
          Resource = [
            "*"
          ],
          Action = [
            "s3:PutObject",
            "s3:GetObject",
            "s3:ListBucket",
            "s3:DeleteObject"
          ]
        },
        {
          Action = [
            "cloudfront:CreateInvalidation",
            "cloudfront:GetDistribution",
            "cloudfront:GetStreamingDistribution",
            "cloudfront:GetDistributionConfig",
            "cloudfront:GetInvalidation",
            "cloudfront:ListInvalidations",
            "cloudfront:ListStreamingDistributions",
            "cloudfront:ListDistributions"
          ],
          Effect = "Allow",
          Resource = [
            "*"
          ],
        },
        {
          Effect = "Allow",
          Resource = [
            aws_s3_bucket.bucket_artifact.arn,
            "${aws_s3_bucket.bucket_artifact.arn}/*"
          ],
          Action = [
            "s3:GetObject",
            "s3:PutObject",
            "s3:PutObjectTagging",
            "s3:GetObjectVersion",
            "s3:GetBucketVersioning",
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "ecr:*"
          ],
          Resource = [
            "*"
          ]
        },
        {
          Effect = "Allow",
          Action = [
            "secretsmanager:GetSecretValue"
          ],
          Resource = "*"
        }
      ]
    }
  )

}

resource "aws_s3_bucket" "bucket_artifact" {
  bucket = "${var.env}-${var.project}-codepipeline-bucket"
  tags   = var.tags
}
resource "aws_s3_bucket_versioning" "bucket_artifact" {
  bucket = aws_s3_bucket.bucket_artifact.id
  versioning_configuration {
    status = "Enabled"
  }
}