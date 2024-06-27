# KinD cluster

Create local Kubernetes in Docker (KinD) clusters for deployment and testing.

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

- install components found in `config` file into all new local clusters:

  - `NGINX=true` will install nginx (as IngressController).

  - `DASHBOARD=true` will install Skooner dashboard. An access token associated with the skooner-sa ServiceAccount is created after the first dashboard startup: such token is printed in `dashbooard-token.yaml` in project root directory, just copy and paste its `.status.token` value into the dashboard login page located from `http://localhost:9080` on.
This is not optimal and I could integrate OIDC with the dashboard instead of generating an access token every time I want to login to the dashboard.

  - `OPERATOR_SDK=true` will install Operator SDK (TODO).

  - `NUM_CLUSTERS` will create more clusters: each component (`NGINX`, `DASHBOARD`, ...) will be installed in every cluster.

  - `EXTRA_MASTERS` will add more master nodes; by default a cluster is created with only one master node.

  - `NUM_WORKERS` will add more worker nodes; by default, a cluster is created with only one worker node.

Once the provisioning is done, you should have a working environment.

**Following commands were necessary when creating more than one cluster:**

```bash
$ sudo sysctl fs.inotify.max_user_instances=1280 # It was 128
$ sudo sysctl fs.inotify.max_user_watches=655360 # It was 65536
```