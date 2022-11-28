output "kubeconfig_file" {
  description = "kubeconfig file of our newly created cluster"
  value       = " Use --kubeconfig ${resource.local_sensitive_file.kubeconfig.filename} with your kubectl "
}

output "ingress_ip" {
  description = "External IP address of our ingress controller. Create an A record to your domain to validate cert request"
  value       = local.ingress_ip
}

output "elastic_passwd" {
  description = "password of the 'elastic' user"
  value       = data.kubernetes_secret_v1.elastic_user.data.password
  sensitive   = true
}

output "elastic_hostname" {
  description = "The elastic hostname"
  value       = var.es_hostname
}

output "kibana_hostname" {
  description = "The kibana hostname"
  value       = var.kibana_hostname
}


# show secret via $ terraform output -json
/* output "secret" {
    description = "Our random password"
    value = resource.random_password.basic_auth_password.result
    sensitive = true
} */
