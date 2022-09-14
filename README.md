# local-kind-cluster

Cluster locale Kubernetes IN Docker (kind) per sviluppi locali.

## Requisiti

go (1.17+), docker, [kind](https://kind.sigs.k8s.io/)

Opzionalmente, Helm

## Versioni

Seguono versioni SW sulla mia PDL:

- go:
    ```
    version go1.19.1 linux/amd64
    ```

- docker:
    ```
    Client: Docker Engine - Community
      Version:           20.10.18
      API version:       1.41
      Go version:        go1.18.6
      Git commit:        b40c2f6
      Built:             Thu Sep  8 23:11:45 2022
      OS/Arch:           linux/amd64
      Context:           default
      Experimental:      true

    Server: Docker Engine - Community
     Engine:
      Version:          20.10.18
      API version:      1.41 (minimum version 1.12)
      Go version:       go1.18.6
      Git commit:       e42327a
      Built:            Thu Sep  8 23:09:37 2022
      OS/Arch:          linux/amd64
      Experimental:     false
     containerd:
      Version:          1.6.8
      GitCommit:        9cd3357b7fd7218e4aec3eae239db1f68a5a6ec6
     runc:
      Version:          1.1.4
      GitCommit:        v1.1.4-0-g5fd4c4d
     docker-init:
      Version:          0.19.0
      GitCommit:        de40ad0
   ```

- kind:
  ```
  kind v0.11.1 go1.17.6 linux/amd64
  ```

- Helm:
  ```
  version.BuildInfo{Version:"v3.7.1+7.el8", GitCommit:"8f33223fe17957f11ba7a88b016bc860f034c4e6", GitTreeState:"clean", GoVersion:"go1.16.7"}
  ```