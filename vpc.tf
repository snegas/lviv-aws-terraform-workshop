module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = local.vpc_name
  cidr = local.cidr

  azs = [
    "${local.region}a",
    "${local.region}b"
  ]

  private_subnets = [
    cidrsubnet(local.cidr, 3, 0),
    cidrsubnet(local.cidr, 3, 1)
  ]

  database_subnets = [
    cidrsubnet(local.cidr, 3, 2),
    cidrsubnet(local.cidr, 3, 3)
  ]

  public_subnets = [
    cidrsubnet(local.cidr, 3, 4),
    cidrsubnet(local.cidr, 3, 5)
  ]

  enable_nat_gateway = true

  vpc_tags = {
    "kubernetes.io/cluster/${local.eks_name}" = "shared"
  }

  public_subnet_tags = {
    "kubernetes.io/role/alb" = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.eks_name}" = "shared"
  }
}