module "vpc" {
  source = "terraform-aws-modules/vpc/aws"
  version = "2.21.0"

  name = "${local.prefix}-vpc"
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
}