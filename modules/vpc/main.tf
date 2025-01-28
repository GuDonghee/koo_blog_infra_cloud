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

  availability_zone       = var.public_subnets.azs[count.index]
  map_public_ip_on_launch = true

  tags = {
    Name      = "${var.vpc_name}-public-subnet-${count.index}"
    ManagedBy = "Terraform"
  }
}

resource "aws_subnet" "private" {
  count      = length(var.private_subnets.cidrs)
  vpc_id     = aws_vpc.this.id
  cidr_block = var.private_subnets.cidrs[count.index]

  availability_zone = var.private_subnets.azs[count.index]

  tags = {
    Name      = "${var.vpc_name}-private-subnet-${count.index}"
    ManagedBy = "Terraform"
  }
}

resource "aws_eip" "eip" {
  count  = length(var.private_subnets.cidrs) == 0 ? 0 : 1
  domain = "vpc"

  tags = {
    Name      = "${var.vpc_name}-nat-eip"
    ManagedBy = "Terraform"
  }
}


resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.this.id

  tags = {
    Name      = "${var.vpc_name}-igw"
    ManagedBy = "Terraform"
  }
}

resource "aws_nat_gateway" "nat" {
  count         = length(var.private_subnets.cidrs) == 0 ? 0 : 1
  allocation_id = aws_eip.eip[0].id
  subnet_id     = aws_subnet.public[var.nat_subnet_index].id

  tags = {
    Name      = "${var.vpc_name}-nat"
    ManagedBy = "Terraform"
  }
}
