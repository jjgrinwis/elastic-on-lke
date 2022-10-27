# now let's install kibana, in this setup using template_file option to create values file
# for kibana we're going to use the same username/password as with elastic
# username: elastic
# password: 'terraform output -json'

resource "helm_release" "kibana" {
  name = "kibana"

  # using elastic as our helm resource
  repository = "https://helm.elastic.co"
  chart      = "kibana"

  # looks like we can't install multiple packages at the same time
  # let's wait until the elastic installation has finished.
  depends_on = [resource.helm_release.elasticsearch]

  # now let's some helm specific vars that will be used during the installation
  # https://artifacthub.io/packages/helm/elastic/kibana

  # let's use some local values file to enable our ingress controller
  # ingress controller will also enable basic auth with bcrypt password stored in kubernetes
  # > templatefile("${path.module}/backends.tftpl", { port = 8080, ip_addrs = ["10.0.0.1", "10.0.0.2"] })
  values = [templatefile("${path.module}/values/kibana-values.tftpl", { secret_name = var.private_key, kibana_hostname = var.kibana_hostname })]
}
