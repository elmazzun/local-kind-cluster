# KinD cluster

A Kubernetes in Docker (KinD) cluster for local deployment and testing 
Kubernetes workloads.

⚠️⚠️⚠️

This repository is designed as my personal cat litter box, where I experiment unsteadily and intermittently.

**Clone this repository at your own risk.**

⚠️⚠️⚠️

Tested on following environment:

```bash
$ lsb_release -a
No LSB modules are available.
Distributor ID:	Linuxmint
Description:	Linux Mint 20.3
Release:	20.3
Codename:	una

$ uname -r
5.15.0-107-generic
```

Running `start.sh` will perform the following tasks:

- before creating local cluster, the script will check if the following programs 
  are installed in your machine and will (try to) install the missing ones:

  - Docker (Community Edition v24.0.5-1)

  - kubectl (v1.28.0)

  - Helm (v3.12.3)

  - KinD

- create the local cluster according to the cluster configuration defined in 
  `./manifests/cluster/create-cluster.yaml` and wait for all the Nodes to be 
  ready;

- install the components found in `config` file into the new local cluster:

  - `nginx=true` will install nginx (as IngressController)

  - `dashboard=true` will install Skooner dashboard. An access token associated with the skooner-sa ServiceAccount is created after the first dashboard startup: such token is printed in `dashbooard-token.yaml` in project root directory, just copy and paste its `.status.token` value into the dashboard login page located at `http://localhost:80`.
This is not optimal and I could integrate OIDC with the dashboard instead of generating an access token every time I want to login to the dashboard.

  - `operator_sdk=true` will install Operator SDK (TODO)

Once the provisioning is done, you should have a working environment.
