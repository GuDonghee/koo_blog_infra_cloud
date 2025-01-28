resource "aws_ecs_cluster" "main" {
  name = "${var.ecs_name}-cluster"

  tags = {
    Name      = "${var.ecs_name}-cluster",
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_task_definition" "main" {
  family                   = "${var.ecs_name}-task"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.task_execution_role.arn
  requires_compatibilities = ["FARGATE"]

  cpu    = 256
  memory = 512

  container_definitions = jsonencode([
    {
      name         = "${var.ecs_name}-server"
      image        = "418272801638.dkr.ecr.ap-northeast-2.amazonaws.com/koo-blog:latest"
      cpu          = 256
      memory       = 512
      portMappings = [
        {
          containerPort = 80
          hostPort      = 80
          protocol      = "tcp"
        }
      ]
    }
  ])

  tags = {
    Name      = "${var.ecs_name}-task-definition",
    ManagedBy = "Terraform"
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.ecs_name}-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.main.arn
  desired_count   = 1
  launch_type = "FARGATE"

  network_configuration {
    subnets         = var.subnet_ids
    security_groups = [aws_security_group.main.id]
  }
}

resource "aws_security_group" "main" {
  description = "Control ecs container inbound and outbound access"
  name        = "${var.ecs_name}-container-sg"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.ecs_name}-containger-sg"
    ManagedBy = "Terraform"
  }
}
