#!/usr/bin/env bash

# https://medium.com/@munza/local-kubernetes-with-kind-helm-dashboard-41152e4b3b3d

set -e

source ./constants.sh
source ./destroy-cluster.sh
# Catching CTRL+c
trap "cleanup_cluster" SIGINT

echo "[1/14] Applying ingress..."
kubectl apply -f manifests/ingress.yaml
echo

echo "[2/14] Waiting for Ingress to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod --selector=app.kubernetes.io/component=controller \
  --timeout="$TIMEOUT_READINESS"
echo

echo "[3/14] Deploying test deployment..."
kubectl apply -f manifests/test-deploy.yaml
echo

echo "[4/14] Adding k8s dashboard Helm chart..."
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
echo

echo "[5/14] Installing k8s dashboard..."
helm install dashboard kubernetes-dashboard/kubernetes-dashboard \
    -n "$K8S_DASHBOARD_NAMESPACE" \
    --create-namespace
echo

echo "[6/14] Waiting for k8s dashboard to be ready..."
kubectl wait --namespace "$K8S_DASHBOARD_NAMESPACE" \
    --for=condition=ready pod --selector=app.kubernetes.io/component=kubernetes-dashboard \
    --timeout="$TIMEOUT_READINESS"
    echo "Dashboard ready at $K8S_DASHBOARD_URL"
echo

echo "[7/14] Adding user for k8s dashboard..."
kubectl apply -f manifests/add-user-to-dashboard.yaml
echo

echo "[8/14] Getting user secret in order to login to k8s dashboard..."
admin_user_token=$(kubectl get serviceaccount admin-user \
    -n "$K8S_DASHBOARD_NAMESPACE" \
    -o jsonpath='{.secrets[0].name}{"\n"}')
echo

echo "[9/14] Returning user secret token: copy/paste this to k8s dashboard login page..."
oc get secret "$admin_user_token" \
    -n "$K8S_DASHBOARD_NAMESPACE" \
    -o jsonpath='{.data.token}' | base64 -d; echo
echo

echo "[10/14] Visit following URL and paste the returned token above..."
echo "$K8S_DASHBOARD_URL"
echo

echo "[11/14] Starting background k8s proxy server..."
kubectl proxy &
echo

echo "[12/14] Installing Prometheus..."
# kill -9 $(fuser 8001/tcp 2> /dev/null | xargs echo)
helm install --wait --timeout "$TIMEOUT_READINESS" \
    --namespace "$PROMETHEUS_NAMESPACE" --create-namespace \
    --repo https://prometheus-community.github.io/helm-charts \
    kube-prometheus-stack kube-prometheus-stack \
    --values - <<EOF
kubeEtcd:
  service:
    targetPort: 2381
EOF
echo

echo "[13/14] Waiting for Prometheus and AlertMangager pods to be ready..."
kubectl wait --namespace="$PROMETHEUS_NAMESPACE" \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=kube-prometheus-stack \
    --timeout="$TIMEOUT_READINESS"

kubectl wait --namespace="$PROMETHEUS_NAMESPACE" \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=kube-prometheus-stack-prometheus \
    --timeout="$TIMEOUT_READINESS"

kubectl wait --namespace="$PROMETHEUS_NAMESPACE" \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=kube-prometheus-stack-alertmanager \
    --timeout="$TIMEOUT_READINESS"
echo "Pods ready: Prometheus dashboard is at $PROMETHEUS_DASHBOARD_URL, no authentication is required"
echo

echo "[14/14] Port forwarding to newly created Prometheus service..."
kubectl port-forward -n "$PROMETHEUS_NAMESPACE" \
    svc/kube-prometheus-stack-prometheus 9090:9090
echo

echo "You may now destroy the cluster by hitting CTRL+c"
