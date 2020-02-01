resource "kubernetes_service_account" "fluentd" {
  metadata {
    name = "fluentd"
    namespace = local.namespace
  }
}

resource "kubernetes_cluster_role" "fluentd" {
  metadata {
    name = "fluentd-role"
  }
  rule {
    api_groups = [""]
    resources = [
      "namespaces",
      "pods",
      "pods/logs"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "fluentd" {
  metadata {
    name = "fluentd-role-binding"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "fluentd-role"
  }

  subject {
    kind = "ServiceAccount"
    name = "fluentd"
    namespace = local.namespace
  }
}