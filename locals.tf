locals {
  region = "us-east-1"

  cidr = "10.0.0.0/16"

  prefix = "lviv-workshop"

  vpc_name = "${local.prefix}-vpc"
  eks_name = "${local.prefix}-cluster"
}