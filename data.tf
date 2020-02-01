data "aws_eks_cluster" "default" {
  name = module.eks-cluster.cluster_id
}

data "aws_eks_cluster_auth" "default" {
  name = module.eks-cluster.cluster_id
}