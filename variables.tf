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