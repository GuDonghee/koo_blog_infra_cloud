variable "vpc_id" {
  description = "VPC 아이디입니다."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC의 IPv4 CIDR입니다."
  type        = string
}

variable "eks_name" {
  description = "EKS 이름. 관련 자원 이름의 Prefix로 사용합니다."
  type        = string
}

variable "subnet_ids" {
  description = "프라이빗 서브넷 아이디 목록"
  type        = list(string)
}

variable "lb_sg_id" {
  description = "로드밸런서의 보안 그룹 ID"
  type        = string
}