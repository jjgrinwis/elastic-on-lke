# Kubernets version to use
# used "linode-cli lke versions-list" to get the available versions
k8s_version = "1.23"

# region for our k8s cluster
region = "eu-central"

# name of our cluster
label = "testing"

# tags assigned to our cluster
tags = ["kibana", "elastic"]

# number of nodes in our cluster
pool_count = 3

# our test user
issuer_email = "john@grinwis.com"