# using the helm provider to install our ingress controller
# our cluster should be active 

# helm charts can be found at: https://artifacthub.io/
# Let's use the offical nginx ingress from:
# https://artifacthub.io/packages/helm/bitnami/nginx-ingress-controller
resource "helm_release" "nginx_ingress" {
  name = "nginx-ingress-controller"

  # using bitnami for our helm repo
  repository = "https://charts.bitnami.com/bitnami"
  chart      = "nginx-ingress-controller"

  # tested with this specific version
  version = "9.3.18"

  # use type loadbalancer to linode nodebalancer is automatically created
  set {
    name  = "service.type"
    value = "LoadBalancer"
  }

  depends_on = [resource.time_sleep.wait_xx_seconds]
}

locals {
  # for readability just store nodebalancer ingress_ip in a var.
  # in the future we might make this less static (0)
  ingress_ip = data.kubernetes_service.nginx_ingress.status.0.load_balancer.0.ingress.0.ip
}

resource "time_sleep" "wait_30_seconds" {
  depends_on      = [resource.helm_release.nginx_ingress]
  create_duration = "30s"
}

# let's lookup our external-ip/nodebalancer ip from our nginx-ingress-controller service
# this might be too quick as we need to wait for the nodebalancer to get an IP.
# so again wait a couple of seconds before looking up this data
data "kubernetes_service" "nginx_ingress" {
  metadata {
    name = resource.helm_release.nginx_ingress.name
  }
  depends_on = [resource.time_sleep.wait_30_seconds]
}

# now lookup ingress ip address we're going that to setup our DNS A record
# cluster should be active so create a depends_on
data "kubernetes_ingress_v1" "example" {
  metadata {
    name = "terraform-example"
  }
  depends_on = [resource.linode_lke_cluster.my-cluster]
}

# specific the correct EdgeDNS credentials
provider "akamai" {
  edgerc         = "~/.edgerc"
  config_section = "gss_training"
}

# when we have our external IP, let's add some A records to EdgeDNS
# let's start with our elasticsearch hostname
# using some regex the strip first part to create domainname
resource "akamai_dns_record" "es-hostname" {
  zone       = regex("([\\w-]*)\\.([\\w-\\.]*)", var.es_hostname)[1]
  name       = var.es_hostname
  recordtype = "A"
  ttl        = 30
  target     = [local.ingress_ip]
}

# when we have our external IP, let's add some A records to EdgeDNS
resource "akamai_dns_record" "kibana-hostname" {
  zone       = regex("([\\w-]*)\\.([\\w-\\.]*)", var.kibana_hostname)[1]
  name       = var.kibana_hostname
  recordtype = "A"
  ttl        = 30
  target     = [local.ingress_ip]
}
