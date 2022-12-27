#!/usr/bin/env bash

set -e

source preflight-checks.sh

# Catching CTRL+c
trap "cleanup_cluster" SIGINT

if ! check_required_sw; then
    echo "Quitting: install required sw before creating kind cluster"
    exit 1
fi

echo "Required sw is already istalled: creating kind cluster..."

kind create cluster --config ./manifests/create-cluster.yaml

kubectl cluster-info --context kind-taccitua

# Pre-installing workloads checks...
echo "Waiting for all nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=600s
echo