variable "cluster_name_prefix" {
  type        = string
  description = "The name of the cluster"
  default     = "test-cluster"
}

variable "nodes_image" {
  type        = string
  description = "Nodes image versions"
  default     = "kindest/node:v1.30.0"
}

variable "helm_chart_dashboard_version" {
  type        = string
  description = "Kubernetes dashboard Helm chart version"
  default     = "7.8.0"
}

variable "helm_chart_prometheus_version" {
  type        = string
  description = "Prometheus stack Helm chart version"
  default     = "65.2.0"
}