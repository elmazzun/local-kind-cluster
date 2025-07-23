resource "helm_release" "tempo" {
  name             = "tempo"
  repository       = "https://grafana.github.io/helm-charts"
  chart            = "tempo-distributed"
  namespace        = "tempo"
  version          = "1.46.0"
  create_namespace = true
  depends_on       = [helm_release.cilium]

  values = [
    "${file("./helm-values/tempo.yaml")}"
  ]
}