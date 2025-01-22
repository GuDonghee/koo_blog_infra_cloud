data "aws_ami" "amazon_linux" {
  most_recent = true
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-2.0.*-x86_64-gp2"]
  }
  owners = ["amazon"]
}

resource "aws_iam_role" "bastion" {
  name               = "${var.bastion_prefix}-bastion"
  assume_role_policy = jsonencode({
    Version   = "2012-10-17",
    Statement = [
      {
        Action    = "sts:AssumeRole"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Effect = "Allow"
      }
    ]
  })

  tags = {
    Name      = "${var.bastion_prefix}-bastion-role"
    ManagedBy = "Terraform"
  }
}

resource "aws_iam_role_policy_attachment" "bastion_policy_attach" {
  role       = aws_iam_role.bastion.id
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "bastion" {
  name = "${var.bastion_prefix}-bastion-instance-profile"
  role = aws_iam_role.bastion.name
}

resource "aws_instance" "this" {
  ami                  = data.aws_ami.amazon_linux.id
  instance_type        = var.instance_type
  iam_instance_profile = aws_iam_instance_profile.bastion.name
  key_name             = var.bastion_key_name
  subnet_id            = var.subnet_id

  vpc_security_group_ids = [
    aws_security_group.bastion.id
  ]

  tags = {
    Name      = "${var.bastion_prefix}-bastion"
    ManagedBy = "Terraform"
  }
}

resource "aws_security_group" "bastion" {
  description = "Control bastion inbound and outbound access"
  name        = "${var.bastion_prefix}-bastion-sg"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name      = "${var.bastion_prefix}-bastion-sg"
    ManagedBy = "Terraform"
  }
}
