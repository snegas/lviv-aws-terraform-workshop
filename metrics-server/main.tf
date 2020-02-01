resource "kubernetes_service_account" "metrics-server" {
  metadata {
    name = local.name
    namespace = local.namespace
  }
}

resource "kubernetes_deployment" "metrics-server" {
  metadata {
    name = local.name
    namespace = local.namespace
    labels = {
      k8s-app = local.name
    }
  }

  spec {
    selector {
      match_labels = {
        k8s-app = local.name
      }
    }

    template {
      metadata {
        name = local.name
        labels = {
          k8s-app = local.name
        }
      }
      spec {
        service_account_name = kubernetes_service_account.metrics-server.metadata.0.name

        volume {
          name = "tmp-dir"
          empty_dir {}
        }

        container {
          name = local.name
          image = "k8s.gcr.io/metrics-server-amd64:v0.3.6"
          image_pull_policy = "Always"
          args = [
            "--cert-dir=/tmp",
            "--secure-port=4443"
          ]

          port {
            name = "main-port"
            container_port = 4443
            protocol = "TCP"
          }

          security_context {
            read_only_root_filesystem = true
            run_as_non_root = true
            run_as_user = 1000
          }

          volume_mount {
            mount_path = "/tmp"
            name = "tmp-dir"
          }
        }
      }
    }
  }
}