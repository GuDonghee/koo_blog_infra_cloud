resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_name}-cluster"

  tags = {
    Name      = "${var.ecs_name}-cluster",
    ManagedBy = "Terraform"
  }
}

resource "aws_cloudwatch_log_group" "ecs_task_logs" {
  name = "${var.ecs_name}-api"

  tags = {
    Name      = "${var.ecs_name}-api-task-logs",
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role" "task_execution_role" {
  name               = "${var.ecs_name}-task-exec-role"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17"
    Statement = [
      {
        Effect    = "Allow"
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = {
    Name      = "${var.ecs_name}-api-task-logs",
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_policy" "task_execution_role_policy" {
  name   = "${var.ecs_name}-task-exec-role-policy"
  path   = "/"
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "ecr:GetAuthorizationToken",
          "ecr:BatchCheckLayerAvailability",
          "ecr:GetDownloadUrlForLayer",
          "ecr:BatchGetImage",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
        ]
        Resource = "*"
      }
    ]
  })

  tags = {
    Name      = "${var.ecs_name}-task-exec-role-policy"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "task-exec-role" {
  role       = aws_iam_role.task_execution_role.name
  policy_arn = aws_iam_policy.task_execution_role_policy.arn
}
