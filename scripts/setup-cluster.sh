#!/usr/bin/env bash

set -e

source ./scripts/destroy-cluster.sh

# Catching CTRL+c will destroy the cluster setup
trap "cleanup_cluster" SIGINT

echo "HIT CTRL+C IN ORDER TO DESTROY THIS CLUSTER"

# Install Ciulium
# docker pull quay.io/cilium/cilium:v1.14.1

# kind load docker-image quay.io/cilium/cilium:v1.14.1 -n mylab

# helm upgrade --install --namespace kube-system --repo https://helm.cilium.io cilium cilium --values - <<EOF
# kubeProxyReplacement: strict
# k8sServiceHost: kind-control-plane
# k8sServicePort: 6443
# hostServices:
#   enabled: false
# externalIPs:
#   enabled: true
# nodePort:
#   enabled: true
# hostPort:
#   enabled: true
# image:
#   pullPolicy: IfNotPresent
# ipam:
#   mode: kubernetes
# hubble:
#   enabled: true
#   relay:
#     enabled: true
#   ui:
#     enabled: true
#     ingress:
#       enabled: true
#       annotations:
#         kubernetes.io/ingress.class: nginx
#       hosts:
#         - hubble-ui.127.0.0.1.nip.io
# EOF

# CILIUM_CLI_VERSION=$(curl -s https://raw.githubusercontent.com/cilium/cilium-cli/main/stable.txt)
# CLI_ARCH=amd64
# if [ "$(uname -m)" = "aarch64" ]; then CLI_ARCH=arm64; fi
# curl -L --fail --remote-name-all https://github.com/cilium/cilium-cli/releases/download/${CILIUM_CLI_VERSION}/cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}
# sha256sum --check cilium-linux-${CLI_ARCH}.tar.gz.sha256sum
# sudo tar xzvfC cilium-linux-${CLI_ARCH}.tar.gz /usr/local/bin
# rm cilium-linux-${CLI_ARCH}.tar.gz{,.sha256sum}

# cilium status --wait

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
# helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
# helm repo update
# # Insecure TLS: no good for production!
# helm upgrade \
#     --install \
#     --set args={--kubelet-insecure-tls} metrics-server metrics-server/metrics-server \
#     -n kube-system

# kubectl wait -n kube-system \
#   --for=condition=ready pod \
#   -l app.kubernetes.io/instance=metrics-server \
#   --timeout=1h

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
kubectl create token skooner-sa \
    -n kube-system \
    --duration 12h \
    -o jsonpath='{.status.token}' > dashboard.token
