resource "kubernetes_service" "metrics-server" {
  metadata {
    name = local.name
    namespace = local.namespace

    labels = {
      "kubernetes.io/name" = "Metrics-server"
      "kubernetes.io/cluster-service" = "true"
    }
  }

  spec {
    selector = {
      k8s-app = local.name
    }

    port {
      port = 443
      protocol = "TCP"
      target_port = "main-port"
    }
  }
}