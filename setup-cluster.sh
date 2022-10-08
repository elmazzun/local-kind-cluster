#!/usr/bin/env bash

# https://medium.com/@munza/local-kubernetes-with-kind-helm-dashboard-41152e4b3b3d

set -e

readonly K8S_DASHBOARD_URL="http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:dashboard-kubernetes-dashboard:https/proxy/#/login"
readonly PROMETHEUS_DASHBOARD_URL="http://localhost:9090/target"
readonly TIMEOUT_READINESS="1h"

# --for=jsonpath='{.status.phase}'=Running

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
    -n kubernetes-dashboard \
    --create-namespace
echo

echo "[6/14] Waiting for k8s dashboard to be ready..."
kubectl wait --namespace kubernetes-dashboard \
  --for=condition=ready pod --selector=app.kubernetes.io/component=kubernetes-dashboard \
  --timeout="$TIMEOUT_READINESS"
echo

echo "[7/14] Adding user for k8s dashboard..."
kubectl apply -f manifests/add-user-to-dashboard.yaml
echo

echo "[8/14] Getting user secret in order to login to k8s dashboard..."
admin_user_token=$(kubectl get serviceaccount admin-user \
    -n kubernetes-dashboard \
    -o jsonpath='{.secrets[0].name}{"\n"}')
echo

echo "[9/14] Returning user secret token: copy/paste this to k8s dashboard login page..."
oc get secret "$admin_user_token" \
    -n kubernetes-dashboard \
    -o jsonpath='{.data.token}' | base64 -d; echo
echo

echo "[10/14] Visit following URL and paste the returned token above..."
echo "$DASHBOARD_URL"
echo

echo "[11/14] Starting background k8s proxy server..."
kubectl proxy &
echo

echo "[12/14] Installing Prometheus..."
helm install --wait --timeout "$TIMEOUT_READINESS" \
    --namespace monitoring --create-namespace \
    --repo https://prometheus-community.github.io/helm-charts \
    kube-prometheus-stack kube-prometheus-stack \
    --values - <<EOF
kubeEtcd:
  service:
    targetPort: 2381
EOF
echo

echo "[13/14] Waiting for Prometheus and AlertMangager pods to be ready..."
kubectl wait --namespace=monitoring \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=kube-prometheus-stack \
    --timeout="$TIMEOUT_READINESS"

kubectl wait --namespace=monitoring \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=kube-prometheus-stack-prometheus \
    --timeout="$TIMEOUT_READINESS"

kubectl wait --namespace=monitoring \
    --for=condition=ready pod \
    --selector=app.kubernetes.io/instance=kube-prometheus-stack-alertmanager \
    --timeout="$TIMEOUT_READINESS"
echo "Pods ready: Prometheus dashboard is at $PROMETHEUS_DASHBOARD_URL, no authentication is required"

echo "[14/14] Port forwarding to newly created Prometheus service..."
kubectl port-forward -n monitoring \
    svc/kube-prometheus-stack-prometheus 9090:9090
echo
