resource "aws_instance" "bastion_host_ec2_instance" {
  ami                     = data.aws_ami.amazon-linux-2.id
  instance_type           = var.instance_type
  subnet_id               = var.subnet_id
  vpc_security_group_ids  = var.bastion_host_security_group_ids
  iam_instance_profile    = var.bastion_iam_role
  disable_api_termination = true

  root_block_device {
    encrypted = true
  }

  monitoring = true

  metadata_options {
    http_endpoint = "enabled"
    http_tokens   = "required"
  }
  tags = {
    Name = "${var.application}-${var.environment}-bastion-host"
  }
}