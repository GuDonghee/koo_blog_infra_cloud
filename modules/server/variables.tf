variable "instance_type" {
  description = "EC2 인스턴스 타입"
  type = string
}

variable "server_key_name" {
  description = "EC2 인스턴스의 키페어 이름"
  type = string
}

variable "vpc_id" {
  description = "VPC 아이디"
  type = string
}

variable "subnet_id" {
  description = "서브넷 아이디"
  type = string
}

variable "server_prefix" {
  description = "EC2 인스턴스의 이름 접두사"
  type = string
}