provider "aws" {
  region = local.region
}

provider "kubernetes" {
  host = data.aws_eks_cluster.default.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.default.certificate_authority.0.data)
  token = data.aws_eks_cluster_auth.default.token
  load_config_file = false
}