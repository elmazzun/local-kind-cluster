resource "helm_release" "minio-operator" {
  name             = "minio-operator"
  repository       = "https://operator.min.io"
  chart            = "operator"
  namespace        = "minio-operator"
  version          = "7.1.1"
  create_namespace = true
  depends_on       = [helm_release.cilium]

  values = [
    "${file("./helm-values/minio-operator.yaml")}"
  ]
}

resource "helm_release" "minio-tenant" {
  name             = "minio-tenant"
  repository       = "https://operator.min.io"
  chart            = "tenant"
  namespace        = "minio-operator"
  version          = "7.1.1"
  create_namespace = true
  depends_on       = [helm_release.minio-operator]

  values = [
    "${file("./helm-values/minio-tenant.yaml")}"
  ]
}