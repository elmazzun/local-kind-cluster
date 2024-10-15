terraform {
  required_providers {
    kind = {
      source  = "tehcyx/kind"
      version = "0.6.0"
    }

    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }

    helm = {
      source = "hashicorp/helm"
      version = "2.15.0"
    }

    null = {
      source = "hashicorp/null"
      version = "3.2.2"
    }
  }
  required_version = "~> 1.9.4"
}

provider "kind" {
}

provider "helm" {
  kubernetes {
    config_path = pathexpand("/tmp/config")
  }
}
