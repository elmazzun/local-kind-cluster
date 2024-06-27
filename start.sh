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

host_http_port=9080
host_https_port=9443

# Create as many kind:Cluster files as required from NUM_CLUSTERS
for ((cluster = 0; cluster < NUM_CLUSTERS; cluster++)); do

    # Copy kind:Cluster template
    cp ./manifests/cluster/create-cluster.yaml.template \
        ./manifests/cluster/create-cluster-$cluster.yaml

    # Rename current cluster
    yq ".name = \"mylab-$cluster\"" \
        -i manifests/cluster/create-cluster-$cluster.yaml

    # Add (extra) master nodes
    for ((master = 0; master < EXTRA_MASTERS; master++)); do
        yq ".nodes += [{\"role\": \"control-plane\"}]" \
            -i manifests/cluster/create-cluster-$cluster.yaml
    done

    # Add worker nodes
    for ((worker = 0; worker < NUM_WORKERS; worker++)); do
        yq ".nodes += [{\"role\": \"worker\"}]" \
            -i manifests/cluster/create-cluster-$cluster.yaml
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
        }' -i manifests/cluster/create-cluster-$cluster.yaml

        sed -i "s/hostPort: 80/hostPort: ${host_http_port}/" \
            manifests/cluster/create-cluster-$cluster.yaml

        sed -i "s/hostPort: 443/hostPort: ${host_https_port}/" \
            manifests/cluster/create-cluster-$cluster.yaml

        host_http_port=$((host_http_port+1))
        host_https_port=$((host_https_port+1))
    fi

done

./scripts/create-cluster.sh && \
    sleep 5 && \
    ./scripts/setup-cluster.sh
