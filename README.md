# Elastic-on-LKE
Terraform scripts to deploy Elastic and Kibana on LKE(Linode Kubernetes Engine). 

Just set your Linode API token as an environment var via ```export TF_VAR_token="xxxx"```, modify some vars in terraform.tfvars  and off you go.

These TF files will create a LKE cluster and will use Helm to install all the required software packages. It will use NGINX as the ingress controller and all certificates will be automaticall created using cert-manager. I've added the Akamai EdgeDNS TF provider to add A records to EdgeDNS. So if using EdgeDNS make sure to use correct permissions from ```~/.edgerc``` file.

By default an "elastic" user will be created used for both elastic and kibana with a random generated password. Password can be retrieved via a ```terraform output -json```.

If anything goes wrong with the certificate request via cert-manager, double check the DNS and make sure you are using a valid issuer email address.
```
$ kubectl apply -f https://k8s.io/examples/admin/dns/dnsutils.yaml --kubeconfig ~/.kube/kube_config
$ kubectl get pods dnsutils --kubeconfig ~/.kube/kube_config
$ kubectl --kubeconfig ~/.kube/kube_config exec -i -t dnsutils -- nslookup kibana.great-demo.com

Server:		10.128.0.10
Address:	10.128.0.10#53

** server can't find kibana.great-demo.com: NXDOMAIN
```
You might need to flush DNS in your cluster to get correct DNS answer.

We now also added some Elastic configuration using TF. It will create an index and set a ingest pipeline to "wash" the datastream input. We also added some mapping config but only for non-text field as Elastic will automatically convert datastream fields to text as datastream.

The only thing you have to do is to create a new data view based on the ds index in the discover section and off you go. If you don't see anything being added, just double check https://<hostname>/ds/_search to check if anything is being added to the index.

I created a datastream config by hand but we should also be able to automate it using the DataStream Akamai TF provider.
<img width="1248" alt="image" src="https://user-images.githubusercontent.com/3455889/202760826-81930bdb-2129-4711-b36a-602c28c1b88a.png">

