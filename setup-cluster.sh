#!/usr/bin/env bash

echo "Applying ingress..."
kubectl apply -f manifests/ingress.yaml
echo

echo "Waiting for ingress to be ready..."
kubectl wait --namespace ingress-nginx \
  --for=condition=ready pod \
  --selector=app.kubernetes.io/component=controller \
  --timeout=90s
echo

echo "Deploying test deployment..."
kubectl apply -f manifests/test-deploy.yaml
echo
