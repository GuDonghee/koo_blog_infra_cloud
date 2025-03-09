output "vpc_id" {
  description = "VPC 아이디"
  value       = aws_vpc.this.id
}

output "public_subnet_ids" {
  description = "퍼블릭 서브넷 아이디 목록"
  value       = try(aws_subnet.public.*.id, null)
}

output "private_subnet_ids" {
  description = "프라이빗 서브넷 아이디 목록"
  value       = try(aws_subnet.private.*.id, null)
}

output "api_lb_target_group_arn" {
  description = "Koo Blog의 로드밸런서 타켓그룹 ARN"
  value       = aws_lb_target_group.main.arn
}

output "lb_sg_id" {
  description = "로드밸런서의 보안 그룹 ID"
  value       = aws_security_group.lb.id
}
