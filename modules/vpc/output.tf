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