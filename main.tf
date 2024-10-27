resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}



resource "aws_eks_cluster" "eks" {
  name     = "techrite-eks-cluster-nonprod"
  role_arn = aws_iam_role.techrite_eks_role.arn

  vpc_config {

    subnet_ids = var.subnet_ranges
  }

  depends_on = [aws_iam_role_policy_attachment.techrite_eks_policy]
}



resource "aws_eks_node_group" "node_group" {
  cluster_name    = aws_eks_cluster.eks.name
  node_group_name = "techrite-worker-node-nonprod"
  node_role_arn   = aws_iam_role.major_node_instance_role.arn
  subnet_ids      = var.subnet_ranges

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }
}
