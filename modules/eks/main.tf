resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.eks_name}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids = var.subnet_ids
  }

  tags = {
    Name      = "${var.eks_name}-cluster",
    ManagedBy = "Terraform"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  
  node_group_name = "${var.eks_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  
  subnet_ids      = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  disk_size = 20

  depends_on = [ aws_eks_cluster.eks_cluster, aws_iam_role.eks_node_role ]

  tags = {
    Name      = "${var.eks_name}-node-group",
    ManagedBy = "Terraform"
  }
}
