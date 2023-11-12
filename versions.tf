# our list of different versions of providers we have to use
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    kubectl = {
      source  = "alekc/kubectl"
      version = ">= 2.0.2"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 2.0.1"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.5.0"
    }
    akamai = {
      source = "akamai/akamai"
    }
    elasticstack = {
      source = "elastic/elasticstack"
    }
  }
  required_version = ">= 0.14"
}
