# TODO

## Install

- [X] cluster monitoring stack
- [X] Cilium monitoring stack
    - [ ] this should be federated to cluster monitoring stack
- [X] Istio
- [X] Kiali
    - [X] link Kiali to cluster monitoring stack
- [X] ArgoCD
    - [ ] point ArgoCD to self-hosted gitea
- [ ] self-hosted Git `gitea`
- [ ] `bookinfo` (with Argo)

## Refactor

- [ ] `kubectl apply` should be using `kubectl` provider, not `null_resource`
- [ ] Prometheus should be Operator-based

## Nice to have

- [ ] deploy more clusters with same Terraform
- [ ] node sizing
- [ ] Istio multicluster
