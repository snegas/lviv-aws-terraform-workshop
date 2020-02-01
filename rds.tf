resource "random_password" "default" {
  length = 10
  special = false
}

module "rds" {
  source = "terraform-aws-modules/rds/aws"
  version = "~> v2.0"

  identifier = "${local.prefix}-rds"

  engine = "postgres"
  engine_version = "11.2"
  instance_class = "db.t3.small"
  allocated_storage = 10
  max_allocated_storage = 100
  storage_type = "gp2"

  subnet_ids = module.vpc.database_subnets
  vpc_security_group_ids = [
    module.rds-sg.this_security_group_id
  ]

  name = "testdb"
  username = "test"
  password = random_password.default.result
  port = 5432

  maintenance_window = "Mon:00:00-Mon:03:00"
  backup_window = "03:00-04:00"
  backup_retention_period = 10

  create_db_option_group = false
  create_db_parameter_group = false
}