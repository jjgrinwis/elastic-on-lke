# Kubernets version to use
# used "linode-cli lke versions-list" to get the available versions
k8s_version = "1.25"

# region for our k8s cluster
# linode-cli regions list --json
region = "eu-central"

# name of the LKE cluster. Kubeconfig will have the same name in ~/.kube dir
# beware, a terraform destroy won't delete the PVC's (volumes)
label = "trimm-demo"

# tags assigned to our cluster
tags = ["kibana", "elastic", "twente"]

# number of nodes in our cluster
pool_count = 3

# ACME issuer email address, should be a valid one.
# letsencrypt will ignore request if using example.com!
# issuer_email = 

# elasticsearch hostname
es_hostname = "trimm-es.great-demo.com"

# kibana hostname
kibana_hostname = "trimm-kibana.great-demo.com"
