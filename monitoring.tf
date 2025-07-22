# prometheus + grafana + alertmanager
resource "helm_release" "monitoring" {
  name             = "prometheus"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  version          = var.helm_chart_prometheus_version
  create_namespace = true
  wait             = true
  timeout          = 300
  depends_on       = [helm_release.cilium]

  values = [
    "${file("./helm-values/prometheus.yaml")}"
  ]
}