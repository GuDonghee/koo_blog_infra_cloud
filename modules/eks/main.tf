resource "aws_eks_cluster" "eks_cluster" {
  name     = "${var.eks_name}-cluster"
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    subnet_ids              = var.subnet_ids
    endpoint_public_access  = false
    endpoint_private_access = true
    security_group_ids      = [aws_security_group.eks_cluster_sg.id]
  }

  tags = {
    Name      = "${var.eks_name}-cluster",
    ManagedBy = "Terraform"
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name = aws_eks_cluster.eks_cluster.name

  node_group_name = "${var.eks_name}-node-group"
  node_role_arn   = aws_iam_role.eks_node_role.arn

  subnet_ids = var.subnet_ids

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  launch_template {
    id      = aws_launch_template.eks_node.id
    version = aws_launch_template.eks_node.latest_version
  }

  depends_on = [aws_eks_cluster.eks_cluster, aws_iam_role.eks_node_role]

  tags = {
    Name      = "${var.eks_name}-node-group",
    ManagedBy = "Terraform"
  }
}

resource "aws_launch_template" "eks_node" {
  name_prefix   = "${var.eks_name}-node"
  instance_type = "t3.medium"

  vpc_security_group_ids = [aws_security_group.eks_nodes_sg.id]

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_size = 20
      volume_type = "gp2"
    }
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name      = "${var.eks_name}-node",
      ManagedBy = "Terraform"
    }
  }
}
