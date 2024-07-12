module "ecs" {
  source = "terraform-aws-modules/ecs/aws"
  cluster_name = var.ecs_configs.name
  cluster_configuration = {
    execute_command_configuration = {
      logging = "OVERRIDE"
      log_configuration = {
        cloud_watch_log_group_name = "/aws/ecs/aws-ec2"
      }
    }
  }

  cluster_settings = [{ "name" : "containerInsights", "value" : "disabled" }]
  fargate_capacity_providers = {
    FARGATE = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
    FARGATE_SPOT = {
      default_capacity_provider_strategy = {
        weight = 50
      }
    }
  }

  services = {
    for key, value in var.configs :
    key => {
      cpu           = 1024
      memory        = 2048
      desired_count = 3
      container_definitions = {
        "ecs-${key}" = {
          cpu       = 1024
          memory    = 2048
          essential = true
          image     = value.image
          command   = value.command
          port_mappings = [
            {
              name          = "ecs-${key}"
              containerPort = value.port
              protocol      = "tcp"
            }
          ]

          readonly_root_filesystem = false
          dependencies = []
          enable_cloudwatch_logging = false
          log_configuration = {
            logDriver : "awslogs",
            options : {
              "awslogs-region" : "us-east-1",
              "awslogs-group" : "ecs/${key}",
              "awslogs-stream-prefix" : "ecs"
            }
          }

          memory_reservation = 100
        }
      }

      load_balancer = {
        service = {
          target_group_arn = module.alb.target_groups["ex_${key}_ecs"].arn
          container_name   = "ecs-${key}"
          container_port   = value.port
        }
      }

      subnet_ids = data.terraform_remote_state.vpc_data.outputs.vpc[var.network_configs.vpc].private_subnets
      security_group_rules = {
        alb_ingress_3000 = {
          type                     = "ingress"
          from_port                = value.port
          to_port                  = value.port
          protocol                 = "tcp"
          description              = "Service port"
          source_security_group_id = module.alb.security_group_id
        }
        egress_all = {
          type        = "egress"
          from_port   = 0
          to_port     = 0
          protocol    = "-1"
          cidr_blocks = ["0.0.0.0/0"]
        }
      }
    }
  }
}

resource "aws_cloudwatch_log_group" "service_logs" {
  for_each = local.services
  name     = "ecs/${each.key}"
}

resource "aws_route53_record" "cname_route53_record" {
  zone_id = data.aws_route53_zone.selected.zone_id
  name    = "web.aws.hugotech.online"
  type    = "CNAME"
  ttl     = "60"
  records = [module.alb.dns_name]
}
