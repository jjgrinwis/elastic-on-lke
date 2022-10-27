# Elastic-on-LKE
Terraform scripts to deploy Elastic and Kibana on LKE(Linode Kubernetes Engine). 

Just set your Linode API token as an environment var via ```export TF_VAR_token="xxxx"```, modify some vars in terraform.tfvars  and off you go.

These TF files will create a LKE cluster and will use Helm to install all the required software packages. It will use NGINX as the ingress controller and all certificates will be automaticall created using cert-manager. I've added the Akamai EdgeDNS TF provider to add A records to EdgeDNS. So if using EdgeDNS make sure to use correct permissions from ```~/.edgerc``` file.

By default an "elastic" user will be created used for both elastic and kibana with a random generated password. Password can be retrieved via a ```terraform output -json```.

[27102022] We now also added some Elastic configuration using TF. It will create an index and set a ingest pipeline to "wash" the datastream input.

I created a datastream config by hand but we should also be able to automate it using the DataStream Akamai TF provider.

