# resource "helm_release" "kiali-operator" {
#   name             = "kiali-operator"
#   repository       = "https://kiali.org/helm-charts"
#   chart            = "kiali-operator"
#   namespace        = "kiali-operator"
# #   version          = "v0.76.0" TODO pin current version
#   create_namespace = true
#   wait             = true
#   timeout          = 300
#   depends_on       = [kind_cluster.new,helm_release.kiali-operator,helm_release.istio-istiod]

#   values = [
#     "${file("./helm-values/kiali-operator.yaml")}"
#   ]
# }

# resource "null_resource" "kiali-server" {

#   provisioner "local-exec" {
#     command = <<EOF
#       kubectl apply -f ./manifests/kiali/kiali-server.yaml
#     EOF
#   }

#   depends_on = [helm_release.kiali-operator,helm_release.istio-istiod]
# }
