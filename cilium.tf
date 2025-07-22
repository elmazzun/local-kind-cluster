resource "helm_release" "cilium" {
  name             = "cilium"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  namespace        = "kube-system"
  version          = var.helm_chart_cilium_version
  wait             = true
  timeout          = 180
  depends_on       = [kind_cluster.default]

  values = [
    "${file("./helm-values/cilium.yaml")}"
  ]
}

resource "null_resource" "load-cilium-image" {
  provisioner "local-exec" {
    command = <<EOF
      docker pull quay.io/cilium/cilium:v${var.helm_chart_cilium_version}
      kind load docker-image quay.io/cilium/cilium:v${var.helm_chart_cilium_version} --name cluster
    EOF
  }

  depends_on = [helm_release.cilium]
}

resource "null_resource" "create-cilium-monitoring-stack" {
  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -f https://raw.githubusercontent.com/cilium/cilium/${var.helm_chart_cilium_version}/examples/kubernetes/addons/prometheus/monitoring-example.yaml
    EOF
  }

  depends_on = [null_resource.load-cilium-image]
}