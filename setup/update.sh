#!/usr/bin/env bash

cristie_control_file="/var/run/cristie-reboot"
cristie_service="cristie-haproxy-install"

continue_after_reboot() {
  ### Running commands before reboot
  echo "Create function to continue after reboot"
  touch $cristie_control_file
  #systemctl $cristie_service enable
  sudo reboot
}

stop_after_reboot() {
  ### Continue after reboot
  echo "Working with last step and will not continue after reboot"
  rm $cristie_control_file
  #systemctl $cristie_service disable
  #systemctl $cristie_service remove
}

update_system() {
  echo "Updating your system with $1"
  $1 $2 -y
  echo $?
}

firewall_settings() {
  ### Setup all Firewall roles for Cloudian
  echo "Fix all Firewall Rules for Cloudian"
  sudo firewall-cmd --add-port=8443/tcp --permanent
  sudo firewall-cmd --add-port=8888/tcp --permanent
  sudo firewall-cmd --add-service=http --permanent
  sudo firewall-cmd --add-service=https --permanent
  sudo firewall-cmd --add-port=19443/tcp --permanent
  sudo firewall-cmd --add-port=16080/tcp --permanent
  sudo firewall-cmd --add-port=16443/tcp --permanent
}

create_user () {
  ### Create HAProxy User
  echo "Create User"
  groupadd -g 188 haproxy
  useradd -g 188 -u 188 -d /var/lib/haproxy -s /sbin/nologin -c haproxy haproxy
}

dependancies_install() {
  ### Install all your dependancies and necessary software
  echo "Installing HAProxy and VMware Tools using $1"
  $1 install -y open-vm-tools haproxy
}

download_config() {
  ### Download Standard Config
  echo "Download configuration"
  wget http://deploy1.cristie.se/cloudian/haproxy.cfg
}

configure_haproxy() {
  ### Configured your hosts
  echo "Start Configure your system"
  echo "Set hostname $1"
  echo -n $1 > /etc/hostname
  echo "Fix IP and Hostname"
  sed -i "s/hyperstore-01/$2/g" haproxy.cfg
  sed -i "s/10.10.2.22/$3/g" haproxy.cfg
  sed -i "s/hyperstore-02/$4/g" haproxy.cfg
  sed -i "s/10.10.2.23/$5/g" haproxy.cfg
  sed -i "s/hyperstore-03/$6/g" haproxy.cfg
  sed -i "s/10.10.2.24/$7/g" haproxy.cfg

  echo "Fixing Domain $8 and Region $9"
  sed -i "s/emea.demo.cloudian.com/$8/g" haproxy.cfg
  sed -i "s/s3-emea/$9/g" haproxy.cfg

}

show_config() {
  echo "HAProxy Hostname: $1";
  echo "Cloudian Base Url: $2";
  echo "Cluster Region Name: $3";
  echo "1st Cloudian Hostname: $4";
  echo "1st Cloudian Host IP: $5";
  echo "2nd Cloudian Hostname: $6";
  echo "2nd Cloudian Host IP: $7";
  echo "3rd Cloudian Hostname: $8";
  echo "3rd Cloudian Host IP: $9";
  pause
}

while getopts a:b:c:d:e:f:g:h:i flag
do
    case "${flag}" in
        a) hostname=${OPTARG};;
        b) clusterUrl=${OPTARG};;
        c) clusterRegion=${OPTARG};;
        d) nodeName1=${OPTARG};;
        e) nodeIp1=${OPTARG};;
        f) nodeName2=${OPTARG};;
        g) nodeIp2=${OPTARG};;
        h) nodeName3=${OPTARG};;
        i) nodeIp3=${OPTARG};;
    esac
done

create_user
firewall_settings
dependancies_install dnf
download_config
show_config $hostname $clusterUrl $clusterRegion $nodeName1 $nodeIp1 $nodeName2 $nodeIp2 $nodeName3 $nodeIp3
configure_haproxy $hostname $clusterUrl $clusterRegion $nodeName1 $nodeIp1 $nodeName2 $nodeIp2 $nodeName3 $nodeIp3

# if [ -f $cristie_control_file ]; then
#   ### Update of the system are done
#   stop_after_reboot
#   create_user
#   firewall_settings
#   dependancies_install dnf
#
# else
#   ### Update your system
#   update_system dnf update
#   continue_after_reboot
