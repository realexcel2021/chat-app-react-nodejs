# backend ECS cluster and service and task definition using modules

data "template_file" "task_def" {
    template = file("./json/backend-task-def.tpl")

    vars = {
      secret_value = aws_secretsmanager_secret.db-endpoint.arn
      log_group    = module.app_ecs_service.awslogs_group
      image        = aws_ecr_repository.be-repo.repository_url
    }
}

data "aws_caller_identity" "current" {}

resource "aws_ecs_cluster" "backend-cluster" {
  name = "snappy-backend-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }
}

module "app_ecs_service" {
  source = "trussworks/ecs-service/aws"

  name        = "snappy-backend-service"
  environment = "prod"

  ecs_cluster                   = aws_ecs_cluster.backend-cluster
  ecs_vpc_id                    = module.vpc.vpc_id
  ecs_subnet_ids                = module.vpc.private_subnets
  kms_key_id                    = aws_kms_key.main.arn
  tasks_desired_count           = 2
  ecs_use_fargate               = true
  assign_public_ip              = false
  manage_ecs_security_group     = false
  container_image               = aws_ecr_repository.be-repo.repository_url 
  additional_security_group_ids = [ module.ecs_sg.security_group_id ]

  logs_cloudwatch_retention     = 7

  container_definitions = data.template_file.task_def.rendered

  

  fargate_task_cpu              = 256
  fargate_task_memory           = 1024

  associate_alb      = true
  alb_security_group = module.ecs_sg.security_group_id
  target_container_name       = "backend-express"
  lb_target_groups = [
    {
      container_port              = 3000
      container_health_check_port = 3000
      lb_target_group_arn         = module.alb-backend.target_groups.backend-tg.arn
    }
  ]
}

# KMS key for the ECS service

data "aws_iam_policy_document" "cloudwatch_logs_allow_kms" {
  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current.account_id}:root",
      ]
    }

    actions = [
      "kms:*",
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow logs KMS access"
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["logs.us-west-2.amazonaws.com"]
    }

    actions = [
      "kms:Encrypt*",
      "kms:Decrypt*",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:Describe*"
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "main" {
  description         = "Key for ECS log encryption"
  enable_key_rotation = true

  policy = data.aws_iam_policy_document.cloudwatch_logs_allow_kms.json
}