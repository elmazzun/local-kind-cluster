# local-kind-cluster

Cluster locale Kubernetes IN Docker (kind) per sviluppi locali.

## Requisiti

I programmi necessari sono cercati dalla funzione `check_required_sw` nel  
file `preflight-checks.sh`, lanciata all'avvio del cluster.

## Avvio

`./create-cluster.sh && ./setup-cluster.sh`

## Releases

- 0.1.0: tutto disabilitato (ingress, dashboard e prometheus); questo è il punto  
         di partenza in cui si può iniziare a sviluppare