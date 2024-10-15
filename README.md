# Local KinD Cluster 

```bash
export KUBECONFIG=/tmp/config

terraform init
terraform plan -out=main.plan
terraform apply main.plan

cat dashboard-admin.token

# Expose k8s dashboard at localhost:8443/ (INCLUDE "/" WHILE ACCESSING DASHBOARD)
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
# Expose Prometheus dashboard
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090
```