#!/usr/bin/env bash

cleanup_cluster() {
    echo "Stopping kubectl proxy..."
    pkill -9 -f "kubectl proxy" || true

    echo "Stopping kubectl port-foward..."
    pkill -9 -f "kubectl port-forward" || true

    # helm repo remove metrics-server || true

    kind delete cluster --name mylab || true
}
