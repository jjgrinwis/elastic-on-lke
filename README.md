# Elastic-on-LKE
Terraform scripts to deploy Elastic and Kibana on LKE(Linode Kubernetes Engine). 

Just set your Linode API token as an environment var via ```export TF_VAR_token="xxxx"```, modify some vars in terraform.tfvars  and off you go.

These TF files will create a LKE cluster and will use Helm to install all the required software packages. It will use NGINX as the ingress controller and all certificates will be automaticall created using cert-manager and Akamai EdgeDNS TF provider used to add the A records to DNS.

By default an "elastic" user will be created used for both elastic and kibana with a random generated password. Password can be retrieved via a ```terraform output -json```.

We now also added some Elastic configuration using TF. It will create an index and set a ingest pipeline to "wash" datastream input
