# now install our cert manager via helm
# somebody created a module to just install cert manager via helm.
# https://registry.terraform.io/modules/terraform-iaac/cert-manager/kubernetes/latest
# this will automatically create a new namespace called cert-manager and will install all CRD's.
# make sure to also include the terraform kubernetes provider otherwise it won't work.
module "cert_manager" {
  source = "terraform-iaac/cert-manager/kubernetes"

  # make sure issuer_email is a valid email address otherwise registration with letsencrypt will fail.
  # kubectl describe ClusterIssuer -n cert-manager --kubeconfig  ~/.kube/testing
  cluster_issuer_email                   = var.issuer_email
  cluster_issuer_name                    = var.issuer_name
  cluster_issuer_private_key_secret_name = var.private_key

  # for whatever reason we can't run two helm installation at the same time
  # so let's wait for 30 seconds after nginx has finished.
  depends_on = [resource.time_sleep.wait_30_seconds]

  # now let's request a cert, this will automatically create an ingress line in cert-manager namespace by default
  # as the private key is stored in default na
  # this ingress will do the redirect back to letsencrypt to validate cert request
  # $ kubectl get ingress -n cert-manager --kubeconfig  ~/.kube/testing
  # DNS A record automatically created by EdgeDNS
  certificates = {
    "my-certificate" = {
      dns_names = [var.es_hostname, var.kibana_hostname]
      namespace = "default"
    }
  }
}
