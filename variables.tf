# flagging token as sensitive, we don't want to store it.
variable "token" {
  type        = string
  description = "Linode API token, sensitive"
  sensitive   = true
}

# looks like v1.23 is the only version avalable so use that as the default
variable "k8s_version" {
  type        = string
  description = "Preferred Kubernets version"
  default     = "1.23"
}

# select the region for your k8s cluster, included some validation
# available regions can be found with "linode-cli regions list --json | jq .""
variable "region" {
  type        = string
  description = "LKE region"
  validation {
    condition     = contains(["eu-central", "eu-west", "us-east"], var.region)
    error_message = "Valid values for the k8s region: are (eu-central, eu-west, us-east)."
  }
}

# the name of your cluster will be the same as your kubeconfig file under ~/.kube
variable "label" {
  type        = string
  description = "The name/label of your k8s cluster and kubeconfig file"
}

variable "tags" {
  type        = set(string)
  description = "List of unique tages assigned to the k8s cluster."
}

variable "pool_count" {
  type        = number
  description = "Number of nodes in our k8s cluster."
  validation {
    condition     = var.pool_count >= 3
    error_message = "We need at least 3 nodes in our cluster"
  }
}

# type of nodes can be found with "linode-cli linodes types"
# for this testing using g6-standard-4 as default value
variable "node_type" {
  type        = string
  description = "The hardware to use as your k8s nodes"
  default     = "g6-standard-4"
}

variable "issuer_email" {
  type        = string
  description = "Email address of issuer of DV cert, should be valid email address."
  default     = "somebody@example.com"
}

variable "issuer_name" {
  type        = string
  description = "Person requesting certifcate"
  default     = "cert-manager-global"
}

variable "es_hostname" {
  type        = string
  description = "elasticsearch hostname"
  default     = "elastic.great-demo.com"
}

variable "kibana_hostname" {
  type        = string
  description = "kibana hostname"
  default     = "kibana.great-demo.com"
}

variable "private_key" {
  type        = string
  description = "Name of your private key in K8S"
  default     = "my-certificate-tls"
}

variable "username" {
  type        = string
  description = "Username for Elastic and Kibana to login"
  default     = "elastic"
}

variable "index_name" {
  type        = string
  description = "The Elastic Index where datastream is going to store it's logs"
  default     = "ds"
}

variable "ingest_pipeline" {
  type        = string
  description = "Name of the Elastic ingest pipeline for datastream"
  default     = "dswm"
}
