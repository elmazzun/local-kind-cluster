#!/usr/bin/env bash

cleanup_cluster() {
    local total_clusters=$(kind get clusters | wc -l)
    echo "Removing $total_clusters clusters..."

    for ((cluster = 0; cluster < total_clusters; cluster++)); do
        # Clean kind:Cluster files
        kind delete cluster --name mylab-$cluster

        # Delete clusters
        rm -f ./manifests/cluster/create-cluster-$cluster.yaml

        # Remove dashboard tokens
        rm -f ./kind-mylab-$cluster-dashboard.token
    done
}
