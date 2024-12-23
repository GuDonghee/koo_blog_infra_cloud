resource "aws_vpc" "this" {
  cidr_block = var.vpc_cidr

  tags = {
    Name      = "${var.vpc_name}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "public" {
  count      = length(var.public_subnets.cidrs)
  vpc_id     = aws_vpc.this.id
  cidr_block = var.public_subnets.cidrs[count.index]

  availability_zone = var.public_subnets.azs[count.index]

  tags = {
    Name      = "${var.vpc_name}-public-subnet"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets.cidrs)
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnets.cidrs[count.index]

  availability_zone = var.private_subnets.azs[count.index]

  tags = {
    Name      = "${var.vpc_name}-private-subnet"
    ManagedBy = "Terraform"
  }
}