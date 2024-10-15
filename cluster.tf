# Since this is a small project, I am going to include ALL resources in this 
# file instead of creating a file for each kind of wanted resource (eg: 
# network.tf, storage.tf, ...)

resource "kind_cluster" "new" {
  name = var.cluster_name_prefix
  node_image = var.nodes_image
  wait_for_ready = true
  kubeconfig_path = pathexpand("/tmp/config")

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    node {
      role = "control-plane"

      kubeadm_config_patches = [
        <<-EOT
        kind: InitConfiguration
        nodeRegistration:
          kubeletExtraArgs:
            node-labels: "ingress-ready=true"
        ---
        # Thanks to https://medium.com/@giorgiodevops/kind-install-prometheus-operator-and-fix-missing-targets-b4e57bcbcb1f
        kind: ClusterConfiguration
        # single master cluster: remove some overhead
        controllerManager:
          extraArgs:
            leader-elect: "false"
        scheduler:
          extraArgs:
            leader-elect: "false"
        # configure controller-manager bind address
        controllerManager:
          extraArgs:
            bind-address: 0.0.0.0
        # configure etcd metrics listen address
        etcd:
          local:
            extraArgs:
              listen-metrics-urls: http://0.0.0.0:2381
        # configure scheduler bind address
        scheduler:
          extraArgs:
            bind-address: 0.0.0.0
        ---
        kind: KubeProxyConfiguration
        # configure proxy metrics bind address
        metricsBindAddress: 0.0.0.0
        EOT
      ]

      extra_port_mappings {
        container_port = 80
        host_port      = 80
      }

      extra_port_mappings {
        container_port = 443
        host_port      = 443
      }
    }

    #   extra_port_mappings {
    #     container_port = 30443
    #     host_port      = 30443
    #   }

    #   extra_port_mappings {
    #     container_port = 30080
    #     host_port      = 30080
    #   }

    #   extra_port_mappings {
    #     container_port = 30021
    #     host_port      = 30021
    #   }
    # }

    # node {
    #   role = "control-plane"
    # }

    # node {
    #   role = "control-plane"
    # }

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }

    # node {
    #   role = "worker"
    # }
  }
}