output "eks_nodes_sg_id" {
  description = "EKS 노드 그룹의 보안 그룹 ID"
  value       = aws_security_group.eks_nodes_sg.id
}
