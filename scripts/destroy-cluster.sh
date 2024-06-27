#!/usr/bin/env bash

cleanup_cluster() {
    echo "Stopping kubectl proxy..."
    pkill -9 -f "kubectl proxy" || true

    echo "Stopping kubectl port-foward..."
    pkill -9 -f "kubectl port-forward" || true

    kind delete cluster --name mylab || true

    # Unsetting env vars
    while read -r line; do
        [[ -n "$line" ]] && export "$line" && echo "unset $line"
    done < config

    # Restore minimal Cluster configuration
    cp ./manifests/cluster/create-cluster.yaml.template \
      ./manifests/cluster/create-cluster.yaml
}
