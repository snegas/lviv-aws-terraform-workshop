resource "kubernetes_api_service" "metrics-server" {
  metadata {
    name = "v1beta1.metrics.k8s.io"
  }

  spec {
    group = "metrics.k8s.io"
    group_priority_minimum = 100
    version = "v1beta1"
    version_priority = 100
    insecure_skip_tls_verify = true
  }
}