#!/usr/bin/env bash

# https://medium.com/@munza/local-kubernetes-with-kind-helm-dashboard-41152e4b3b3d

set -e

readonly DASHBOARD_URL="http://localhost:8001/api/v1/namespaces/kubernetes-dashboard/services/https:dashboard-kubernetes-dashboard:https/proxy/#/login"
readonly TIMEOUT_INGRESS_READINESS="60s"
readonly TIMEOUT_DASHBOARD_READINESS="60s"

echo "[1/11] Applying ingress..."
kubectl apply -f manifests/ingress.yaml
echo

echo "[2/11] Waiting for Ingress to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout="$TIMEOUT_INGRESS_READINESS"
echo

echo "[3/11] Deploying test deployment..."
kubectl apply -f manifests/test-deploy.yaml
echo

echo "[4/11] Adding k8s dashboard Helm chart..."
helm repo add kubernetes-dashboard https://kubernetes.github.io/dashboard/
echo

echo "[5/11] Installing k8s dashboard..."
helm install dashboard kubernetes-dashboard/kubernetes-dashboard \
    -n kubernetes-dashboard \
    --create-namespace
echo

echo "[6/11] Waiting for k8s dashboard to be ready..."
kubectl wait --namespace kubernetes-dashboard \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=kubernetes-dashboard \
  --timeout="$TIMEOUT_DASHBOARD_READINESS"
echo

echo "[7/11] Adding user for k8s dashboard..."
kubectl apply -f manifests/add-user-to-dashboard.yaml
echo

echo "[8/11] Getting user secret in order to login to k8s dashboard..."
admin_user_token=$(kubectl get serviceaccount admin-user \
    -n kubernetes-dashboard \
    -o jsonpath='{.secrets[0].name}{"\n"}')
echo

echo "[9/11] Returning user secret token: copy/paste this to k8s dashboard login page..."
oc get secret "$admin_user_token" \
    -n kubernetes-dashboard \
    -o jsonpath='{.data.token}{"\n"}'
echo

echo "[10/11] Visit following URL and paste the returned token above..."
echo "$DASHBOARD_URL"
echo

echo "[11/11] Starting k8s proxy server..."
kubectl proxy
