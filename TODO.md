## TODO

- [X] deployare un cluster kind (almeno un master e un worker)
- [ ] installare una dashboard Kubernetes
  - [ ] Da Kubernetes 1.24 in poi quando un ServiceAccount viene creato, bisogna
        creare manualmente il Secret ad esso associato: sistemare
- [X] installare Prometheus
  - [X] https://medium.com/@devopscons/kind-install-prometheus-operator-and-fix-missing-targets-b4e57bcbcb1f
  - [X] https://medium.com/@charled.breteche/kind-fix-missing-prometheus-operator-targets-1a1ff5d8c8ad
- [ ] fornire una scelta di quale app deployare al momento della creazione del cluster
  - [ ] implementare attesa di readiness per l'app scelta per il deploy
- [ ] installare ECK
- [ ] installare Istio
- [ ] come installare un Operator su kind