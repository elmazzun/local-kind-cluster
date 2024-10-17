resource "helm_release" "kubernetes-dashboard" {
  name             = "kubernetes-dashboard"
  repository       = "https://kubernetes.github.io/dashboard"
  chart            = "kubernetes-dashboard"
  namespace        = "kubernetes-dashboard"
  version          = var.helm_chart_dashboard_version
  create_namespace = true
  wait             = true
  timeout          = 180
  depends_on       = [kind_cluster.default]
}

# Use secret in dashboard-admin.token in order to login to dashboard
resource "null_resource" "dashboard-configuration" {
  provisioner "local-exec" {
    command = <<EOF
      kubectl apply -f ./manifests/dashboard
    EOF
  }

  depends_on = [helm_release.kubernetes-dashboard]
}

# Write K8s dashboard access token in a file
resource "null_resource" "extract-token" {
  provisioner "local-exec" {
    command = <<EOF
      kubectl get secret admin-user \
          -n kubernetes-dashboard \
          -o jsonpath='{.data.token}{"\n"}' | base64 -d > ${path.module}/dashboard-admin.token
    EOF
  }

  depends_on = [null_resource.dashboard-configuration]
}