resource "kubernetes_namespace" "amazon-cloudwatch" {
  metadata {
    name = local.namespace

    labels = {
      name = local.namespace
    }
  }
}