#!/usr/bin/env bash

cleanup_cluster() {
    echo "Stopping kubectl proxy..."
    pkill -9 -f "kubectl proxy" || true
    echo

    echo "Stopping kubectl port-foward..."
    pkill -9 -f "kubectl port-forward" || true
    echo

    echo "Destroying kind cluster..."
    kind delete cluster --name taccitua || true
    echo
}
