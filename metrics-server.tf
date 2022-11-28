# we want to see some metrics like cpu usage, let's install metrics server
# https://artifacthub.io/packages/helm/metrics-server/metrics-server

resource "helm_release" "metrics-server" {
  name = "metrics-server"

  # using kubernetes-sigs as source
  repository = "https://kubernetes-sigs.github.io/metrics-server/"
  chart      = "metrics-server"
  version    = "3.8.2"

  # we need to ignore cert errors when using LKE
  values = [
    "${file("${path.module}/values/ms-values.yaml")}"
  ]

  # need to find out how we can use a list of objects to feed into helm as a set
  # as example below is not working so using values file
  /* set {
    name  = "args"
    value = "['--kubelet-insecure-tls']"
  } */

  # looks like we can't install multiple packages at the same time
  # let's wait until the kibana installation has finished.
  depends_on = [resource.helm_release.kibana]

}
