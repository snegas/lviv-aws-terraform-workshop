module "public-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"
  name = "${local.prefix}-public-sg"

  ingress_cidr_blocks = ["0.0.0.0/0"]
  ingress_rules = ["all-all"]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  vpc_id = module.vpc.vpc_id
}

module "private-sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  ingress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = module.public-sg.this_security_group_id
    }
  ]

  egress_cidr_blocks = ["0.0.0.0/0"]
  egress_rules = ["all-all"]

  name = "${local.prefix}-private-sg"
  vpc_id = module.vpc.vpc_id
}

module "rds-sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  name = "${local.prefix}-postgresql-sg"
  vpc_id = module.vpc.vpc_id

  ingress_with_source_security_group_id = [
    {
      rule = "postgresql-tcp"
      source_security_group_id = module.private-sg.this_security_group_id
    }
  ]

  egress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = module.private-sg.this_security_group_id
    }
  ]
}

module "node-to-master-sg" {
  source = "terraform-aws-modules/security-group/aws"
  version = "3.4.0"

  name = "${local.prefix}-node-to-master-sg"
  vpc_id = module.vpc.vpc_id

  egress_with_source_security_group_id = [
    {
      rule = "all-all"
      source_security_group_id = module.public-sg.this_security_group_id
    }
  ]
}