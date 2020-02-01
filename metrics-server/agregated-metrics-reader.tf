resource "kubernetes_cluster_role" "aggregated-metrics-reader" {
  metadata {
    name = "system:aggregated-metrics-reader"

    labels = {
      "rbac.authorization.k8s.io/aggregate-to-view" = "true"
      "rbac.authorization.k8s.io/aggregate-to-edit" = "true"
      "rbac.authorization.k8s.io/aggregate-to-admin" = "true"
    }
  }

  rule {
    api_groups = [
      "metrics.k8s.io"
    ]

    resources = [
      "pods",
      "nodes"
    ]

    verbs = [
      "get",
      "list",
      "watch"
    ]
  }
}