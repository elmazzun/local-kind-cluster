# prometheus + grafana + alertmanager
resource "helm_release" "monitoring" {
  name             = "kube-prometheus-stack"
  repository       = "https://prometheus-community.github.io/helm-charts"
  chart            = "kube-prometheus-stack"
  namespace        = "monitoring"
  # version          = TODO pin current version
  create_namespace = true
  wait             = true
  timeout          = 300
  depends_on       = [kind_cluster.default]

  values = [
    "${file("./helm-values/prometheus.yaml")}"
  ]
}