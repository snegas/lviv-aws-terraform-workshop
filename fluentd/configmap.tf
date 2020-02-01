resource "kubernetes_config_map" "fluentd-to-cloudwatch" {
  metadata {
    name = "cluster-info"
    namespace = local.namespace
  }

  data = {
    "cluster.name" = var.clustername
    "logs.region" = var.region
  }
}

resource "kubernetes_config_map" "fluent-config" {
  metadata {
    name = "fluentd-config"
    namespace = local.namespace

    labels = {
      k8s-app = "fluentd-cloudwatch"
    }
  }

  data = {
    "fluent.conf" = file("${path.module}/configs/fluent.conf")
    "containers.conf" = file("${path.module}/configs/containers.conf")
    "systemd.conf" = file("${path.module}/configs/systemd.conf")
    "host.conf" = file("${path.module}/configs/host.conf")
  }
}