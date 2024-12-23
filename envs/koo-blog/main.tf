locals {
  vpc_cidr       = "10.1.0.0/16"

  public_subnets = {
    cidrs = ["10.1.64.0/18"]
    azs   = ["ap-northeast-2c"]
  }

  private_subnets = {
    cidrs = ["10.1.128.0/18"]
    azs   = ["ap-northeast-2c"]
  }
}

module "vpc" {
  source = "../../modules/vpc"
  vpc_name = "koo-blog"
  vpc_cidr = local.vpc_cidr
  public_subnets = local.public_subnets
  private_subnets = local.private_subnets
}