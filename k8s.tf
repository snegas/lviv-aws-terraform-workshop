module "k8s-metrics-server" {
  source = "./metrics-server"
}

module "fluentd" {
  source = "./fluentd"

  clustername = local.eks_name
  region = local.region
}