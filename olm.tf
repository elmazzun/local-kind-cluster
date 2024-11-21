resource "null_resource" "deploy-operator-lifecycle-manager" {
  provisioner "local-exec" {
    command = "operator-sdk olm install --version v0.28.0"
  }

  depends_on = [kind_cluster.default]
}