output "kubeconfig_file" {
    description = "kubeconfig file of our newly created cluster"
    value = " Use --kubeconfig ${resource.local_sensitive_file.kubeconfig.filename} with your kubectl "
}

output "ingress_ip" {
    description = "External IP address of our ingress controller. Create an A record to your domain to validate cert request"
    value = local.ingress_ip
}

# show secret via $ terraform output -json
output "secret" {
    description = "Our random password"
    value = resource.random_password.basic_auth_password.result
    sensitive = true
}