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
