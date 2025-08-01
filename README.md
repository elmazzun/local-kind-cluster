# Local KinD Cluster 

Create a [kind](https://kind.sigs.k8s.io/) cluster using 
[tehcyx](https://github.com/tehcyx/terraform-provider-kind)
Terraform provider.

Following components will be installed via [Helm](https://registry.terraform.io/providers/hashicorp/helm/latest)
Terraform provisioner:

- [kubernetes dashboard](https://github.com/kubernetes/dashboard): a general-
purpose web UI for Kubernetes clusters

- [Cilium](https://github.com/cilium/cilium): eBPF-based networking, security 
and observability.

- [Prometheus stack (kube-prometheus-stack)](https://github.com/prometheus-community/helm-charts/tree/main/charts/kube-prometheus-stack): 
AlertManager, Grafana, kube-state-metrics, Node Exporter, Prometheus

![image info](./graph.png)

# Create kind cluster

Run the following commands in your shell:

```bash
export KUBECONFIG=/tmp/config

terraform init
terraform plan -out=main.plan
terraform apply main.plan

# Use this to login in k8s dashboard
cat dashboard-admin.token

# Expose k8s dashboard at https://localhost:8443/ (LAST "/" IS ESSENTIAL)
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
# Expose Prometheus dashboard
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090
```
