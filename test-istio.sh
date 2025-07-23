#!/bin/bash

kubectl create ns red
# kubectl label namespace red istio.io/dataplane-mode=ambient
kubectl label namespace red istio-injection=enabled
kubectl -n red apply -f <(curl -s https://raw.githubusercontent.com/cilium/cilium/1.17.6/examples/kubernetes-istio/httpbin.yaml)
kubectl -n red apply -f <(curl -s https://raw.githubusercontent.com/cilium/cilium/1.17.6/examples/kubernetes-istio/netshoot.yaml)
kubectl create ns blue
# kubectl label namespace blue istio.io/dataplane-mode=ambient
kubectl label namespace blue istio-injection=enabled
kubectl -n blue apply -f <(curl -s https://raw.githubusercontent.com/cilium/cilium/1.17.6/examples/kubernetes-istio/httpbin.yaml)
kubectl -n blue apply -f <(curl -s https://raw.githubusercontent.com/cilium/cilium/1.17.6/examples/kubernetes-istio/netshoot.yaml)
kubectl create ns green
kubectl -n green apply -f https://raw.githubusercontent.com/cilium/cilium/1.17.6/examples/kubernetes-istio/netshoot.yaml

sleep 10

while true; do
    kubectl exec -n red deploy/netshoot -- curl http://httpbin.red/ip -s -o /dev/null -m 1 -w "client 'red' to server 'red': %{http_code}\n"
    kubectl exec -n blue deploy/netshoot -- curl http://httpbin.red/ip -s -o /dev/null -m 1 -w "client 'blue' to server 'red': %{http_code}\n"
    kubectl exec -n green deploy/netshoot -- curl http://httpbin.red/ip -s -o /dev/null -m 1 -w "client 'green' to server 'red': %{http_code}\n"
    kubectl exec -n red deploy/netshoot -- curl http://httpbin.blue/ip -s -o /dev/null -m 1 -w "client 'red' to server 'blue': %{http_code}\n"
    kubectl exec -n blue deploy/netshoot -- curl http://httpbin.blue/ip -s -o /dev/null -m 1 -w "client 'blue' to server 'blue': %{http_code}\n"
    kubectl exec -n green deploy/netshoot -- curl http://httpbin.blue/ip -s -o /dev/null -m 1 -w "client 'green' to server 'blue': %{http_code}\n"
    sleep 3
done