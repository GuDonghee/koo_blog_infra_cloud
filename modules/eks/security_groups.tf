resource "aws_security_group" "eks_cluster_sg" {
  name        = "${var.eks_name}-cluster-sg"
  description = "Security group for EKS cluster"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [var.vpc_cidr]
    description = "Allow VPC traffic to communicate with the cluster API Server"
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.eks_name}-cluster-sg"
  }
}

# EKS 노드 그룹 보안 그룹
resource "aws_security_group" "eks_nodes_sg" {
  name        = "${var.eks_name}-nodes-sg"
  description = "Security group for EKS worker nodes"
  vpc_id      = var.vpc_id

  # 노드 간 통신을 위한 인바운드 규칙
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    self        = true
    description = "Allow nodes to communicate with each other"
  }

  # 클러스터 보안 그룹에서 노드로의 통신 허용
  ingress {
    from_port       = 1025
    to_port         = 65535
    protocol        = "tcp"
    security_groups = [aws_security_group.eks_cluster_sg.id]
    description     = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  }

  # 로드밸런서에서 노드로의 웹 트래픽 허용 (80, 443 포트)
  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [var.lb_sg_id]
    description     = "Allow HTTP traffic from the load balancer"
  }

  ingress {
    from_port       = 443
    to_port         = 443
    protocol        = "tcp"
    security_groups = [var.lb_sg_id]
    description     = "Allow HTTPS traffic from the load balancer"
  }

  # 아웃바운드 규칙 - 모든 트래픽 허용
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Allow all outbound traffic"
  }

  tags = {
    Name = "${var.eks_name}-nodes-sg"
    ManagedBy = "Terraform"
  }
}
