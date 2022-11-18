# Kubernets version to use
# used "linode-cli lke versions-list" to get the available versions
k8s_version = "1.23"

# region for our k8s cluster
region = "eu-central"

# name of our cluster
label = "customer-demo"

# tags assigned to our cluster
tags = ["kibana", "elastic", "demo"]

# number of nodes in our cluster
pool_count = 3

# our test user
issuer_email = "john@grinwis.com"

# elasticsearch hostname
es_hostname = "es.great-demo.com"

#kibana hostname
kibana_hostname = "kiba.great-demo.com"
