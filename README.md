# Cristie Tier2 HAProxy
Cristie Tier 2 is a on-premise S3 solution build on Cloudian.
Read more at [cristienordic.com](https://content.cristienordic.com/cloudbrik_t2)

## Pre Requirements
Install a standard CentOS 8 in VMware with following specification
* 2 vCPU
* 4 GB Memory
* 16Gb SATA Disk


## Installation
You have a kickstart script included in this package that install Fedora Server 33.
If you want to use Redhat Enterprise Linux, CentOS or Fedora manually, please install the latest version.

### Run the configuration
To run the configuration copy and paste this line with your values.

`sudo ./install.sh -a haproxy01 -b emea.company.com -c s3-emea -d node1 -e 1.1.1.1 -f node2 -g 2.2.2.2 -h node3 -i 3.3.3.3`

### Run HAProxy 2.3.1
HAProxy 2.x is not included in Fedora 33 or any CentOS release so far. There for have I create this extra installer that installing HAProxy from source code.

`sudo ./install-2.3.1.sh -a haproxy01 -b emea.company.com -c s3-emea -d node1 -e 1.1.1.1 -f node2 -g 2.2.2.2 -h node3 -i 3.3.3.3`

## Kubernetes Openshift
Create a new project on your OpenShift Cluster.
`oc new-project cloudian`

Deploy the HAProxy in your Openshift Cluster
`oc process -f ./haproxy.yaml -p DOMAIN=emea.cristie.se -p REGION=emea -p IP1=10.0.0.11 -p IP2=10.0.0.12 -p IP3=10.0.0.13 | oc create -f -`
