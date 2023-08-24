# KinD cluster

A Kubernetes in Docker (KinD) cluster for local deployment and testing 
Kubernetes workloads.

**Tested on a virtualized Debian 12.**

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

- sleep for 5 seconds;

- install the following components in the new local cluster:

  - nginx (as IngressController)

  - metrics server

  - Skooner dashboard

Once the provisioning is done, you should have a working environment: you 
  can test such environment by running the following command and `OK!` string 
  should be printed at the end.
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

An access token associated with the skooner-sa service account should be 
created for each login after the first dashboard startup, copied and pasted 
into the dashboard login page located at `http://localhost:80`.

```bash
# Copy/paste this token to the dashboard login page
$ kubectl create token skooner-sa -n kube-system
eyJh...wxyz
```

This is not optimal and I could integrate OIDC with the dashboard instead 
of generating an access token every time I want to login to the dashboard.
