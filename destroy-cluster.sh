#!/usr/bin/env bash

echo "Stopping kubectl proxy..."
pkill -9 -f "kubectl proxy"
echo

echo "Destroying kind cluster..."
kind delete cluster --name local-kind-cluster
echo
