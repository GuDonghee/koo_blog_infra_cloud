output "vpc_id" {
  description = "VPC 아이디"
  value       = aws_vpc.this.id
}

output "public_subnet_id" {
  description = "퍼블릭 서브넷 아이디"
  value       = try(aws_subnet.public.*.id, null)
}