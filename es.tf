# now we're going to install elastic
# we can't use Elastic on K8S as we need a license for it.
# https://artifacthub.io/packages/helm/elastic/elasticsearch
resource "helm_release" "elasticsearch" {
  name = "elasticsearch"

  # using elastic as our helm resource
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"

  # specif the specific version of our helm chart
  # https://artifacthub.io/packages/helm/elastic/elasticsearch
  version = "8.5.1"

  # as we can't install two packages at the same time via helm
  # so let's wait until nginx controller and cert_manager have been installed
  depends_on = [resource.helm_release.nginx_ingress, resource.akamai_dns_record.kibana-hostname, module.cert_manager]

  # now let's some helm specific vars that will be used during the installation
  # https://artifacthub.io/packages/helm/elastic/elasticsearch?modal=values

  # let's use some local values file to enable our ingress controller
  # ingress controller will also enable basic auth with bcrypt password stored in kubernetes
  values = [
    "${file("${path.module}/values/es-values.yaml")}"
  ]

  # below some set examples. 
  # this is our ingress hostname
  set {
    name  = "ingress.hosts.0.host"
    value = var.es_hostname
  }

  # the path we should be listening for
  set {
    name  = "ingress.hosts.0.paths.0.path"
    value = "/"
  }

  # the private key
  set {
    name  = "ingress.tls[0].secretName"
    value = "my-certificate-tls"
  }

  # and our tls hostname
  set {
    name  = "ingress.tls[0].hosts[0]"
    value = var.es_hostname
  }
}

# first create a random password resource user for basic authentication
/* resource "random_password" "basic_auth_password" {
  length           = 16
  special          = true
  override_special = "_@"
} */

# we're using the "elastic" user that is automatically created
# check password via: 
# 1. Retrieve the elastic user's password.
#  $ kubectl get secrets --namespace=default elasticsearch-master-credentials -ojsonpath='{.data.password}' | base64 -d
# 2. Retrieve the kibana service account token.
# $ kubectl get secrets --namespace=default kibana-kibana-es-token -ojsonpath='{.data.token}' | base64 -d

/* # store that password as bcrypt password for user elastic in kubernetes
# bcrypt is used by htpasswd which nginx is using for basic auth
# https://itnext.io/adding-basic-auth-to-ingress-nginx-using-terraform-c9c09f857378
# type=Opaque for arbitrary data
resource "kubernetes_secret" "basic_auth_secret" {
  type = "Opaque"
  metadata {
    name = "basic-auth"
  }
  data = {
    "auth" : "${var.username}:${bcrypt(random_password.basic_auth_password.result)}"
  }
} */
