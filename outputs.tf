output "kubeconfig" {
  value = kind_cluster.new.kubeconfig
}

output "endpoint" {
  value = kind_cluster.new.endpoint
}

output "client_certificate" {
  value = kind_cluster.new.client_certificate
}

output "client_key" {
  value = kind_cluster.new.client_key
}

output "cluster_ca_certificate" {
  value = kind_cluster.new.cluster_ca_certificate
}

output "dashboard_token_file_path" {
  value = "${path.module}/dashboard-admin.token"
}