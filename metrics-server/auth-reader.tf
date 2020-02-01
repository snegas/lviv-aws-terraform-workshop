resource "kubernetes_role_binding" "auth-reader" {
  metadata {
    name = "metrics-server-auth-reader"
    namespace = "kube-system"
  }

  role_ref {
    api_group = "rbac.authorization.k8s.io"
    kind = "Role"
    name = "extension-apiserver-authentication-reader"
  }
  subject {
    kind = "ServiceAccount"
    name = local.name
    namespace = local.namespace
  }
}