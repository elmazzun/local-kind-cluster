terraform {
  required_providers {
    # kind terraform provider 0.9.0:
    # - kind actual version: 0.27.0
    # - default node image: 1.32.2
    kind = {
      source  = "tehcyx/kind"
      version = "0.9.0"
    }

    helm = {
      source = "hashicorp/helm"
      version = "3.0.2"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.4"
    }
  }
  required_version = "1.12.2"
}

provider "kind" {
}

provider "helm" {
  kubernetes = {
    config_path = pathexpand("/tmp/config")
  }
}