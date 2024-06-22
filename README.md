# KinD cluster

A Kubernetes in Docker (KinD) cluster for local deployment and testing 
Kubernetes workloads.

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

  - Docker

  - kubectl

  - Helm

  - KinD

- create the local cluster according to the cluster configuration defined in 
  `./manifests/cluster/create-cluster.yaml` and wait for all the Nodes to be 
  ready;

- install the components found in `config` file into the new local cluster:

  - `nginx=true` will install nginx (as IngressController)

  - `dashboard=true` will install Skooner dashboard

  - `cilium=true` will install Cilium

  - `operator_sdk=true` will install Operator SDK (TODO)

Once the provisioning is done, you should have a working environment: you can test such environment by running the following command and `OK!` string should be printed at the end.

  ```bash
  # The following command will perform the following task:
  # 1. pull and run the hello-world Docker image
  # 2. create a single-node KinD cluster
  # 3. list the running containers in the VM
  # 4. destroy the single-node KinD cluster created at step 2.
  # 5. celebrate your working cluster with a heartening "OK!"
  $ docker run hello-world \
        && kind create cluster \
        && docker ps \
        && kind delete cluster \
        && echo "OK!"
  ```

An access token associated with the skooner-sa ServiceAccount is created after the first dashboard startup: such token is printed in `dashbooard-token.yaml` in project root directory, just copy and paste its `.status.token` value into the dashboard login page located at `http://localhost:80`.
This is not optimal and I could integrate OIDC with the dashboard instead of generating an access token every time I want to login to the dashboard.
