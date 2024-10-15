# Local KinD Cluster 

```bash
export KUBECONFIG=/tmp/config

terraform init
terraform plan -out=main.plan
terraform apply -auto-approve

cat dashboard-admin.token

# Esponi dashboard k8s a localhost:8443/ (INCLUDI ULTIMO SLASH DI URL)
kubectl -n kubernetes-dashboard port-forward svc/kubernetes-dashboard-kong-proxy 8443:443
# Esponi dashboard Prometheus
kubectl -n monitoring port-forward svc/kube-prometheus-stack-prometheus 9090
```