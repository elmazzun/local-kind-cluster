#!/usr/bin/env bash

set -e

source ./scripts/destroy-cluster.sh
source ./scripts/preflight-checks.sh

# Catching CTRL+c
trap "cleanup_cluster" SIGINT

if ! check_required_sw; then
    echo "Installing required sw before creating kind cluster..."
else
    echo "Required sw is already istalled: creating kind cluster..."
fi

# If the cluster fails to create, try again with the --retain option 
# (preserving the failed container), then run kind export logs to export 
# the logs from the container to a temporary directory on the host.
kind create cluster \
    --config ./manifests/cluster/create-cluster.yaml

kubectl cluster-info --context kind-mylab

# Pre-installing workloads checks...
echo "Waiting for all nodes to be ready..."
kubectl wait --for=condition=Ready nodes --all --timeout=600s
echo
