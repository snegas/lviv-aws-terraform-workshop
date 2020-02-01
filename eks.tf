module "eks-cluster" {
  source = "terraform-aws-modules/eks/aws"
  cluster_name = local.eks_name
  cluster_version = "1.14"
  subnets = module.vpc.public_subnets
  vpc_id = module.vpc.vpc_id
  config_output_path = "./tmp/kubeconfig"
//  write_kubeconfig = false
//  manage_aws_auth = false

  cluster_enabled_log_types = [
    "api",
    "audit",
    "authenticator",
    "controllerManager",
    "scheduler"
  ]

  worker_groups = [
    {
      instance_type = "t3.small"
      asg_min_size = 2
      asg_max_size = 6
      asg_desired_capacity = 2
      subnets = module.vpc.private_subnets
      additional_security_group_ids = [
        module.node-to-master-sg.this_security_group_id
      ]
    }
  ]
}

resource "aws_iam_policy" "cloudwatch-access" {
  name = "${local.prefix}-allow-push-to-cloudwatch"
  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "logs",
            "Effect": "Allow",
            "Action": [
                "logs:CreateLogStream",
                "logs:PutLogEvents",
                "logs:DescribeLogGroups",
                "logs:DescribeLogStreams"
            ],
            "Resource": [
                "arn:aws:logs:*:*:*"
            ]
        }
    ]
}
EOF

}

resource "aws_iam_role_policy_attachment" "cloudwatch-access" {
  role = module.eks-cluster.worker_iam_role_name
  policy_arn = aws_iam_policy.cloudwatch-access.arn
}