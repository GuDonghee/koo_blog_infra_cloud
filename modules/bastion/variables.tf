variable "vpc_id" {
  description = "VPC 아이디"
  type = string
}

variable "subnet_id" {
  description = "서브넷 아이디"
  type = string
}

variable "instance_type" {
  description = "EC2 인스턴스의 AMI 아이디"
  type = string
}

variable "bastion_key_name" {
  description = "EC2 인스턴스의 키페어 이름"
  type = string
}

variable "bastion_prefix" {
  description = "EC2 인스턴스의 이름 접두사"
  type = string
}
