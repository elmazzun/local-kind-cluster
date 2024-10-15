# resource "null_resource" "namespace_app" {

#   provisioner "local-exec" {
#     command = <<EOF
#       kubectl get namespace app || kubectl create namespace app
#       kubectl label namespace app istio-injection=enabled --overwrite
#     EOF
#   }

#   depends_on = [kind_cluster.new]
# }

# resource "null_resource" "namespace_istio-system" {

#   provisioner "local-exec" {
#     command = <<EOF
#       kubectl get namespace istio-system || kubectl create namespace istio-system
#     EOF
#   }

#   depends_on = [kind_cluster.new]
# }

# resource "null_resource" "namespace_istio-ingress" {

#   provisioner "local-exec" {
#     command = <<EOF
#       kubectl get namespace istio-ingress || kubectl create namespace istio-ingress
#     EOF
#   }

#   depends_on = [kind_cluster.new]
# }

# resource "null_resource" "namespace_kiali-server" {

#   provisioner "local-exec" {
#     command = <<EOF
#       kubectl get namespace kiali || kubectl create namespace kiali
#     EOF
#   }

#   depends_on = [kind_cluster.new]
# }
