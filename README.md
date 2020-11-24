# Cristie Tier2 HAProxy
Cristie Tier 2 is a on-premise S3 solution build on Cloudian.
Read more at [cristienordic.com](https://content.cristienordic.com/cloudbrik_t2)

## Pre Requirements
Install a standard CentOS 8 in VMware with following specification
* 2 vCPU
* 4 GB Memory
* 16Gb SATA Disk

### Run
sudo ./update.sh -a haproxy01 -b emea.company.com -c s3-emea -d node1 -e 1.1.1.1 -f node2 -g 2.2.2.2 -h node3 -i 3.3.3.3
