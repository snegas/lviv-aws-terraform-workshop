module "eks-cluster" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = "${local.prefix}-cluster"
  cluster_version = "1.14"
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  config_output_path = "./tmp/kubeconfig"

  worker_groups = [
    {
      instance_type = "t3.small"
      asg_min_size = 2
      asg_max_size = 6
      subnets = module.vpc.private_subnets
    }
  ]
}