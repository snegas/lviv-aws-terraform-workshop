resource "kubernetes_cluster_role" "metrics-server" {
  metadata {
    name = "system:${local.name}"
  }
  rule {
    api_groups = [""]
    resources = [
      "pods",
      "nodes",
      "nodes/stats",
      "namespaces",
      "configmaps"
    ]
    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}

resource "kubernetes_cluster_role_binding" "metrics-server" {
  metadata {
    name = "system:${local.name}"
  }
  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "ClusterRole"
    name = "system:${local.name}"
  }
  subject {
    kind = "ServiceAccount"
    name = local.name
    namespace = local.namespace
  }
}