# our list of different versions of providers we have to use
terraform {
  required_providers {
    linode = {
      source = "linode/linode"
    }
    kubectl = {
      source  = "gavinbunney/kubectl"
      version = ">= 1.13.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = ">= 1.13"
    }
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.1.0"
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
