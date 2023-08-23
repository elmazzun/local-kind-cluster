#!/usr/bin/env bash

set -e

source ./scripts/destroy-cluster.sh

# Catching CTRL+c will destroy the cluster setup
trap "cleanup_cluster" SIGINT

echo "HIT CTRL+C IN ORDER TO DESTROY THIS CLUSTER"

# Install ingress nginx
kubectl \
    apply -f \
    https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

kubectl wait -n ingress-nginx \
  --for=condition=ready pod \
  -l app.kubernetes.io/component=controller \
  --timeout=1h

# Install metrics server (optional)
# Check https://github.com/kubernetes-sigs/metrics-server#requirements
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo update
# Insecure TLS: no good for production!
helm upgrade \
    --install \
    --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server \
    -n kube-system

kubectl wait -n kube-system \
  --for=condition=ready pod \
  -l app.kubernetes.io/instance=metrics-server \
  --timeout=1h

# Install Skooner dashboard
kubectl \
    apply -f \
    https://raw.githubusercontent.com/skooner-k8s/skooner/master/kubernetes-skooner.yaml

kubectl wait -n kube-system \
  --for=condition=ready pod \
  -l k8s-app=skooner \
  --timeout=1h

# Expose dashboard
kubectl \
    apply -f \
    manifests/dashboard/expose-dashboard.yaml

# Create a ServiceAccount in order to login to dashboard
kubectl create serviceaccount skooner-sa -n kube-system

# Give that service account root on the cluster
kubectl create clusterrolebinding \
    skooner-sa --clusterrole=cluster-admin \
    --serviceaccount=kube-system:skooner-sa

# Copy/paste this token in the dashboard login page
kubectl create token skooner-sa -n kube-system
