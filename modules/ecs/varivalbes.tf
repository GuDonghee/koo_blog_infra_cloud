variable "vpc_id" {
  description = "VPC 아이디"
  type = string
}

variable "ecs_name" {
  description = "ECS 이름. 관련 자원 이름의 Prefix로 사용합니다."
  type        = string
}

variable "subnet_ids" {
  description = "프라이빗 서브넷 아이디 목록"
  type        = list(string)
}