resource "kind_cluster" "default" {
  name = var.cluster_name_prefix
  node_image = var.nodes_image
  wait_for_ready = false
  kubeconfig_path = pathexpand("/tmp/config")

  kind_config {
    kind = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"

    networking {
      disable_default_cni = true
    }

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

    node {
      role = "worker"
    }

    node {
      role = "worker"
    }
  }
}