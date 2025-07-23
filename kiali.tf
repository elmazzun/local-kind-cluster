resource "helm_release" "kiali" {
  name             = "kiali-operator"
  repository       = "https://kiali.org/helm-charts"
  chart            = "kiali-operator"
  namespace        = "istio-system"
  version          = "2.13.0"
  depends_on = [helm_release.cilium]

  values = [
    "${file("./helm-values/kiali.yaml")}"
  ]
}