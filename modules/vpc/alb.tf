resource "aws_lb" "main" {
  name               = "${var.vpc_name}-lb"
  load_balancer_type = "application"

  subnets = [
    aws_subnet.public[0].id,
    aws_subnet.public[1].id,
  ]

  security_groups = [aws_security_group.lb.id]

  tags = {
    Name      = "${var.vpc_name}-lb"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_target_group" "main" {
  name        = "${var.vpc_name}-api"
  protocol    = "HTTP"
  vpc_id      = aws_vpc.this.id
  target_type = "ip"
  port        = 80

  health_check {
    enabled             = true
    interval            = 30
    path                = "/posts"
    matcher             = "200-299"
    protocol            = "HTTP"
    unhealthy_threshold = 10
  }

  tags = {
    Name      = "${var.vpc_name}-lb-target-group"
    ManagedBy = "Terraform"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }

  tags = {
    Name      = "${var.vpc_name}-http-listener"
    ManagedBy = "Terraform"
  }
}
