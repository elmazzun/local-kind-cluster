#!/usr/bin/env bash

set -e

source ./scripts/destroy-cluster.sh
source ./scripts/preflight-checks.sh

# Catching CTRL+c
trap "cleanup_cluster" SIGINT

if ! check_required_sw; then
    echo "Installing required sw before creating kind cluster..."
else
    echo "Required sw is already installed: creating kind cluster..."
fi

# If the cluster fails to create, try again with the --retain option 
# (preserving the failed container), then run kind export logs to export 
# the logs from the container to a temporary directory on the host.
for ((c = 0; c < NUM_CLUSTERS; c++)); do
    echo "Creating cluster #$c..."
    # cp ./manifests/cluster/create-cluster.yaml.template \
    #   ./manifests/cluster/create-cluster-$c.yaml

    kind create cluster \
        --config ./manifests/cluster/create-cluster-$c.yaml

    kubectl cluster-info --context kind-mylab-$c

    # Pre-installing workloads checks...
    echo "Waiting for all cluster kind-mylab-$c nodes to be ready..."
    kubectl wait --for=condition=Ready nodes \
        --all --timeout=300s \
        --context kind-mylab-$c

    echo
done
