#!/usr/bin/env bash

set -e

source ./scripts/destroy-cluster.sh

# Catching CTRL+c will destroy the cluster setup
trap "cleanup_cluster" SIGINT

echo "Hit CTRL+C in order to abort cluster init"

function install_nginx() {
    local cluster_id="kind-mylab-$1"
    kubectl config use-context $cluster_id
    echo ">>> $FUNCNAME in $cluster_id"

    kubectl \
        apply -f \
        https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

    kubectl wait -n ingress-nginx \
        --for=condition=ready pod \
        -l app.kubernetes.io/component=controller \
        --timeout=5m
}

function install_dashboard() {
    local cluster_id="kind-mylab-$1"
    kubectl config use-context $cluster_id
    echo ">>> $FUNCNAME in $cluster_id"

    kubectl \
        apply -f \
        https://raw.githubusercontent.com/skooner-k8s/skooner/master/kubernetes-skooner.yaml

    kubectl wait -n kube-system \
        --for=condition=ready pod \
        -l k8s-app=skooner \
        --timeout=5m

    # Expose dashboard
    kubectl \
        apply -f \
        manifests/dashboard/expose-dashboard.yaml

    # Create a ServiceAccount in order to login to dashboard
    kubectl create serviceaccount skooner-sa \
        -n kube-system

    # Give that service account root on the cluster
    kubectl create clusterrolebinding \
        skooner-sa --clusterrole=cluster-admin \
        --serviceaccount=kube-system:skooner-sa

    # Copy/paste this token in the dashboard login page
    kubectl create token skooner-sa \
        -n kube-system \
        --duration 12h \
        -o jsonpath='{.status.token}{"\n"}' > $cluster_id-dashboard.token
}

function install_operator_sdk() {
    echo ">>> $FUNCNAME"
}

for ((cluster = 0; cluster < NUM_CLUSTERS; cluster++)); do
    [[ $NGINX == true ]] && install_nginx $cluster \
        || echo "Skipping nginx installation on kind-mylab-$cluster"

    [[ $DASHBOARD == true ]] && install_dashboard $cluster \
        || echo "Skipping dashboard installation on kind-mylab-$cluster"

    [[ $OPERATOR_SDK == true ]] && install_operator_sdk $cluster \
        || echo "Skipping Operator SDK installation on kind-mylab-$cluster"
done
