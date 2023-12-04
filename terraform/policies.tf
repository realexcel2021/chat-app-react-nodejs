##############################################################################
# Includes all the IAM policies that are attached to roles created by modules
##############################################################################

# policy for ECS backend task to retrieve secrets

resource "aws_iam_policy" "ssm-policy" {
  name        = "ecs-backend-task-ssm-policy"
  path        = "/"
  description = "Policy for ECS backend tasks to get secrets from Secrets manager"

  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ssm:GetParameters",
        "secretsmanager:GetSecretValue"
        ]
        Effect   = "Allow"
        Resource = [
            "${aws_secretsmanager_secret.db-endpoint.arn}"
        ]
      },
    ]
  })
}

resource "aws_iam_policy_attachment" "ssm-attach" {
  name       = "ecs-backend-ssm-attach"
  roles      = [ module.app_ecs_service.task_role_name ]
  policy_arn = aws_iam_policy.ssm-policy.arn
}
