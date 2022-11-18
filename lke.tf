# all required Terraform providers have been moved to versions.tf

# for now storing our API token in an environment var.
# token can be found in ~/.config/linode_cli if you have the cli already configured!
# we might want to change this to a vault
provider "linode" {
  token = var.token
}

# we're going to use helm, define some config
provider "helm" {
  kubernetes {
    config_path = resource.local_sensitive_file.kubeconfig.filename
  }
}

provider "kubectl" {
  config_path = resource.local_sensitive_file.kubeconfig.filename
}

# this will give an output warning as file is not there when first settin up the cluster
# can be ignored
provider "kubernetes" {
  config_path = resource.local_sensitive_file.kubeconfig.filename
}

locals {
  # create normal file output from base64 encoded config file
  kube_config = base64decode(resource.linode_lke_cluster.my-cluster.kubeconfig)
}

# let's create our lke resource
# sit back and relax, this could take around 10 minutes!
# but if for whatever reason it's not working, just kill the TF script and delete created linode via portal or cli
resource "linode_lke_cluster" "my-cluster" {
  label       = var.label
  k8s_version = var.k8s_version
  region      = var.region
  tags        = var.tags

  pool {
    type  = var.node_type
    count = var.pool_count

    # not using the autoscaler function 
    /* autoscaler {
          min = 3
          max = 10
        } */
  }
}

# create the local kubeconfig file and store in the default directory in your home dir.
# that filename can be used in other data/resource calls. 
resource "local_sensitive_file" "kubeconfig" {
  content         = local.kube_config
  filename        = pathexpand("~/.kube/${var.label}")
  file_permission = "0600"
}

# during testing looks like helm is already trying to create stuff but LKE is not fully finished
# so let's wait for 120 seconds before continuing installing the software.
# we might want to look for some other option to check if LKE if fully up and running
resource "time_sleep" "wait_xx_seconds" {
  depends_on      = [resource.local_sensitive_file.kubeconfig]
  create_duration = "60s"
}
