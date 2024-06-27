#!/usr/bin/env bash

set -e

# This file will invoke scripts that will create the cluster; before doing 
# that, YAML files will be edited accorded to components you wish to install;
# such components will be discovered after parsing config file.

if ! [[ -f ./config ]]; then
    echo "config file does not exist. Quitting"
    exit 1
fi

# Exporting variables in config files so that they can be seen in 
# other scripts
while read -r line; do
    [[ -n "$line" ]] && export "$line" && echo "export $line"
done < config

# Add (extra) master nodes
for ((master = 0; master < EXTRA_MASTERS; master++)); do
    yq ".nodes += [{\"role\": \"control-plane\"}]" \
        -i manifests/cluster/create-cluster.yaml
done

# Add worker nodes
for ((worker = 0; worker < NUM_WORKERS; worker++)); do
    yq ".nodes += [{\"role\": \"worker\"}]" \
        -i manifests/cluster/create-cluster.yaml
done

# nginx
# https://kind.sigs.k8s.io/docs/user/ingress/#create-cluster
if [[ $NGINX == true ]]; then
    yq '.nodes[0] += {
    "kubeadmConfigPatches": [
        "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\""
    ],
    "extraPortMappings": [
        {"containerPort": 80, "hostPort": 80, "protocol": "TCP"},
        {"containerPort": 443, "hostPort": 443, "protocol": "TCP"}
    ]
    }' -i manifests/cluster/create-cluster.yaml
fi

./scripts/create-cluster.sh && \
    sleep 5 && \
    ./scripts/setup-cluster.sh
