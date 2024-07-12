module "alb" {
  source  = "terraform-aws-modules/alb/aws"
  version = "~> 9.0"
  name    = var.alb_configs.name

  load_balancer_type = "application"

  vpc_id = data.terraform_remote_state.vpc_data.outputs.vpc[var.network_configs.vpc].vpc_id

  subnets = data.terraform_remote_state.vpc_data.outputs.vpc[var.network_configs.vpc].public_subnets

  enable_deletion_protection = false

  security_group_ingress_rules = {
    all_http = {
      from_port   = 80
      to_port     = 80
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
    all_https = {
      from_port   = 443
      to_port     = 443
      ip_protocol = "tcp"
      cidr_ipv4   = "0.0.0.0/0"
    }
  }

  security_group_egress_rules = {
    all = {
      ip_protocol = "-1"
      cidr_ipv4   = data.terraform_remote_state.vpc_data.outputs.vpc[var.network_configs.vpc].vpc_cidr_block
    }
  }

  listeners = {
    ex-http-https-redirect = {
      port     = 80
      protocol = "HTTP"
      redirect = {
        port        = "443"
        protocol    = "HTTPS"
        status_code = "HTTP_301"
    } }

    ex_https = {
      port            = 443
      protocol        = "HTTPS"
      ssl_policy      = "ELBSecurityPolicy-TLS13-1-2-Res-2021-06"
      certificate_arn = data.aws_acm_certificate.issued.arn

      forward = {
        target_group_key = "ex_default"
      }
      rules = {
        for key, value in var.configs :
        "ex-${key}-rule" => {
          actions = [
            {
              type             = "forward"
              target_group_key = "ex_${key}_ecs"
            }
          ]

          conditions = [{
            host_header = {
              values = [value.domain]
            }
          }]
        }
      }
    }
  }

  target_groups = merge(
    {
      ex_default = {
        backend_protocol                  = "HTTP"
        backend_port                      = 80
        target_type                       = "ip"
        deregistration_delay              = 5
        load_balancing_cross_zone_enabled = false

        health_check = {
          enabled             = true
          healthy_threshold   = 5
          interval            = 30
          matcher             = "200"
          path                = "/"
          port                = 80
          protocol            = "HTTP"
          timeout             = 5
          unhealthy_threshold = 2
        }
        create_attachment = false
      }
      }, {
      for key, value in var.configs :
      "ex_${key}_ecs" => {
        protocol                          = "HTTP"
        port                              = value.port
        target_type                       = "ip"
        deregistration_delay              = 5
        load_balancing_cross_zone_enabled = true

        health_check = {
          enabled             = value.enabled_health_check
          healthy_threshold   = 5
          interval            = 30
          matcher             = "200"
          path                = value.health_check_path
          port                = value.port
          protocol            = "HTTP"
          timeout             = 5
          unhealthy_threshold = 2
        }

        create_attachment = false
      }
    }
  )
}
