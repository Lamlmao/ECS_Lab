resource "aws_iam_role" "bastion-host-instance-role" {
  managed_policy_arns = var.bastion_host_policy.managed_policy_arns
  dynamic "inline_policy" {
    for_each = var.bastion_host_policy.inline_policy
    content {
      name   = inline_policy.value["name"]
      policy = inline_policy.value["policy"]
    }
  }

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "ec2.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_instance_profile" "bastion-host-instance-profile" {
  role = aws_iam_role.bastion-host-instance-role.name
}
