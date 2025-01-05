data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  key_name      = var.server_key_name

  vpc_security_group_ids = [
    aws_security_group.server.id
  ]

  tags = {
    Name      = "${var.server_prefix}-server"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "server" {
  name   = "${var.server_prefix}-server"
  vpc_id = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name     = "${var.server_prefix}-server-security-group"
    ManageBy = "Terraform"
  }
}
