resource "helm_release" "cilium" {
  name             = "cilium"
  repository       = "https://helm.cilium.io/"
  chart            = "cilium"
  namespace        = "kube-system"
  version          = var.helm_chart_cilium_version
  # create_namespace = true
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
      docker pull quay.io/cilium/cilium:v1.17.5
      kind load docker-image quay.io/cilium/cilium:v1.17.5 --name cluster
    EOF
  }

  depends_on = [helm_release.cilium]
}