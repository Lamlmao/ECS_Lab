resource "aws_iam_policy" "readonly" {
  count = var.create_iam_policy ? 1 : 0

  name = format("%s-secretmanager-readonly-access-policy", var.component)
  path = "/"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "secretsmanager:GetResourcePolicy",
          "secretsmanager:GetSecretValue",
          "secretsmanager:DescribeSecret",
          "secretsmanager:ListSecretVersionIds",
        ]
        Effect = "Allow"
        Resource = [
          aws_secretsmanager_secret.this.arn,
        ]
      },
      {
        Action = [
          "secretsmanager:ListSecrets",
        ]
        Effect   = "Allow"
        Resource = ["*"]
      },
    ]
  })

  tags = merge(local.tags, {
    Name = format("%s-secretmanager-readonly-access-policy", var.component)
  })
}