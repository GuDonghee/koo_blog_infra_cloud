resource "aws_security_group" "lb" {
  description = "Allow access to Application Load Balancer"
  name = "${var.vpc_name}-lb-sg"
  vpc_id = aws_vpc.this.id

  ingress {
    protocol = "tcp"
    from_port = 80
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol = "tcp"
    from_port = 433
    to_port = 433
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.vpc_name}-lb-sg"
    ManagedBy = "Terraform"
  }
}
