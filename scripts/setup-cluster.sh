#!/usr/bin/env bash

set -e

source ./scripts/destroy-cluster.sh

# Catching CTRL+c will destroy the cluster setup
trap "cleanup_cluster" SIGINT

echo "Hit CTRL+C in order to abort cluster init"

function install_nginx() {
    # Install ingress nginx
    echo ">>> $FUNCNAME"
    kubectl \
        apply -f \
        https://raw.githubusercontent.com/kubernetes/ingress-nginx/main/deploy/static/provider/kind/deploy.yaml

    kubectl wait -n ingress-nginx \
        --for=condition=ready pod \
        -l app.kubernetes.io/component=controller \
        --timeout=1h
}

function install_dashboard() {
    echo ">>> $FUNCNAME"
    kubectl \
        apply -f \
        https://raw.githubusercontent.com/skooner-k8s/skooner/master/kubernetes-skooner.yaml

    kubectl wait -n kube-system \
    --for=condition=ready pod \
    -l k8s-app=skooner \
    --timeout=1h

    # Expose dashboard
    kubectl \
        apply -f \
        manifests/dashboard/expose-dashboard.yaml

    # Create a ServiceAccount in order to login to dashboard
    kubectl create serviceaccount skooner-sa -n kube-system

    # Give that service account root on the cluster
    kubectl create clusterrolebinding \
        skooner-sa --clusterrole=cluster-admin \
        --serviceaccount=kube-system:skooner-sa

    # Copy/paste this token in the dashboard login page
    kubectl create token skooner-sa \
        -n kube-system \
        --duration 12h \
        -o jsonpath='{.status.token}{"\n"}' > dashboard.token
}

function install_operator_sdk() {
    echo ">>> $FUNCNAME"
}

[[ $NGINX == true ]] && install_nginx \
    || echo "Skipping nginx installation"

[[ $DASHBOARD == true ]] && install_dashboard \
    || echo "Skipping dashboard installation"

[[ $OPERATOR_SDK == true ]] && install_operator_sdk \
    || echo "Skipping Operator SDK installation"
