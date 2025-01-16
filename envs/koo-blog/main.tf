terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-northeast-2"
}

locals {
  vpc_cidr = "10.1.0.0/16"

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
  source          = "../../modules/vpc"
  vpc_name        = "koo-blog"
  vpc_cidr        = local.vpc_cidr
  public_subnets  = local.public_subnets
  private_subnets = local.private_subnets
}

module "bastion" {
  source           = "../../modules/bastion"
  vpc_id           = module.vpc.vpc_id
  subnet_id        = module.vpc.public_subnet_ids[0]
  instance_type    = "t2.micro"
  bastion_key_name = "koo-blog-bastion"
  bastion_prefix   = "koo-blog"
}

module "ecs" {
  source     = "../../modules/ecs"
  ecs_name = "koo-blog"
}
