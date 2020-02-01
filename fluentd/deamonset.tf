resource "kubernetes_daemonset" "default" {
  metadata {
    name = "fluentd-cloudwatch"
    namespace = "amazon-cloudwatch"
  }

  spec {
    selector {
      match_labels = {
        k8s-app = "fluend-cloudwatch"
      }
    }

    template {
      metadata {
        labels = {
          k8s-app = "fluend-cloudwatch"
        }
      }

      spec {
        service_account_name = "fluentd"
        automount_service_account_token = true

        termination_grace_period_seconds = 30

        volume {
          name = "config-volume"
          config_map {
            name = "fluentd-config"
          }
        }

        volume {
          name = "fluentdconf"
          empty_dir {}
        }

        volume {
          name = "varlog"
          host_path {
            path = "/var/log"
          }
        }

        volume {
          name = "varlibdockercontainers"
          host_path {
            path = "/var/lib/docker/containers"
          }
        }

        volume {
          name = "runlogjournal"
          host_path {
            path = "/run/log/journal"
          }
        }

        volume {
          name = "varlogdmesg"
          host_path {
            path = "/var/log/dmesg"
          }
        }

        container {
          name = "fluentd-cloudwatch"
          image = "fluent/fluentd-kubernetes-daemonset:v1.7.3-debian-cloudwatch-1.0"

          env {
            name = "REGION"
            value_from {
              config_map_key_ref {
                name = "cluster-info"
                key = "logs.region"
              }
            }
          }

          env {
            name = "CLUSTER_NAME"
            value_from {
              config_map_key_ref {
                name = "cluster-info"
                key = "cluster.name"
              }
            }
          }

          env {
            name = "CI_VERSION"
            value = "k8s/1.0.1"
          }

          resources {
            limits {
              memory = "400Mi"
            }

            requests {
              cpu = "100m"
              memory = "200Mi"
            }
          }

          volume_mount {
            mount_path = "/config-volume"
            name = "config-volume"
          }

          volume_mount {
            mount_path = "/fluentd/etc"
            name = "fluentdconf"
          }

          volume_mount {
            mount_path = "/var/log"
            name = "varlog"
          }

          volume_mount {
            mount_path = "/var/lib/docker/containers"
            name = "varlibdockercontainers"
          }

          volume_mount {
            mount_path = "/run/log/journal"
            name = "runlogjournal"
          }

          volume_mount {
            mount_path = "/var/log/dmesg"
            name = "varlogdmesg"
            read_only = true
          }
        }

        init_container {
          name = "copy-fluentd-config"
          image = "busybox"
          command = [
            "sh", "-c", "cp /config-volume/..data/* /fluentd/etc"
          ]

          volume_mount {
            mount_path = "/config-volume"
            name = "config-volume"
          }

          volume_mount {
            mount_path = "/fluentd/etc"
            name = "fluentdconf"
          }
        }

        init_container {
          name = "update-log-driver"
          image = "busybox"
          command = ["sh", "-c", ""]
        }
      }
    }
  }
}