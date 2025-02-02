variable "vpc_name" {
  description = "VPC 이름. 관련 자원 이름의 Prefix로 사용합니다."
  type        = string
}

variable "vpc_cidr" {
  description = "VPC의 IPv4 CIDR입니다."
  type        = string
}

variable "public_subnets" {
  description = "해당 VPC의 퍼블릭 서브넷의 CIDR 목록입니다."
  type        = map(list(string))
  default     = {}
}

variable "private_subnets" {
  description = "해당 VPC의 프라이빗 서브넷의 CIDR 목록입니다."
  type        = map(list(string))
  default     = {}
}

variable "nat_subnet_index" {
  description = "NAT 게이트웨이가 생성될 서브넷의 인덱스입니다."
  type        = number
}

variable "api_lb_port" {
  description = "Koo-Blog로 향하는 로드밸런서의 포트"
  type        = number
  default     = 80
}
