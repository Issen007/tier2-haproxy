#!/usr/bin/env bash

cristie_control_file="/var/run/cristie-reboot"
cristie_service="cristie-haproxy-install"

continue_after_reboot() {
  ### Running commands before reboot
  touch $cristie_control_file
  #systemctl $cristie_service enable
  sudo reboot
}

stop_after_reboot() {
  ### Continue after reboot
  rm $cristie_control_file
  #systemctl $cristie_service disable
  #systemctl $cristie_service remove
}

update_system() {
  $1 $2 -y
  echo $?
}

firewall_settings() {
  ### Setup all Firewall roles for Cloudian
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
  groupadd -g 188 haproxy
  useradd -g 188 -u 188 -d /var/lib/haproxy -s /sbin/nologin -c haproxy haproxy
}

dependancies_install() {
  ### Install all your dependancies and necessary software
  $1 install -y open-vm-tools haproxy
}

download_config() {
  ### Download Standard Config
  wget http://deploy1.cristie.se/cloudian/haproxy.cfg
}

configure_haproxy() {
  ### Configured your hosts
  echo -n $1 > /etc/hostname
  sed -i "s/hyperstore-01/$2/g" haproxy.cfg
  sed -i "s/10.10.2.22/$3/g" haproxy.cfg
  sed -i "s/hyperstore-02/$4/g" haproxy.cfg
  sed -i "s/10.10.2.23/$5/g" haproxy.cfg
  sed -i "s/hyperstore-03/$6/g" haproxy.cfg
  sed -i "s/10.10.2.24/$7/g" haproxy.cfg
  sed -i "s/emea.demo.cloudian.com/$8/g" haproxy.cfg
  sed -i "s/s3-emea/$9/g" haproxy.cfg

}

echo "HAProxy Hostname: $1";
echo "Cloudian Base Url: $8";
echo "Cluster Region Name: $9";
echo "1st Cloudian Hostname: $2";
echo "1st Cloudian Host IP: $3";
echo "2nd Cloudian Hostname: $4";
echo "2nd Cloudian Host IP: $5";
echo "3rd Cloudian Hostname: $6";
echo "3rd Cloudian Host IP: $7";

create_user
firewall_settings
dependancies_install dnf
download_config
configure_haproxy $1 $2 $3 $4 $5 $6 $7 $8 $9



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
