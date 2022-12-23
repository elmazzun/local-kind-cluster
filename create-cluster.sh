#!/usr/bin/env bash

set -e

source preflight-checks.sh
source ./destroy-cluster.sh
# Catching CTRL+c
trap "cleanup_cluster" SIGINT

if ! check_required_sw; then
    echo "Quitting: install required sw before creating kind cluster"
    exit 1
fi

echo "Required sw is already istalled: creating kind cluster..."

kind create cluster --config ./manifests/create-cluster.yaml

kubectl cluster-info --context kind-local-kind-cluster
