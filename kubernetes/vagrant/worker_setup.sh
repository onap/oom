#!/bin/bash
set -ex

sudo apt-get -y install ntp
cat << EOF | sudo tee /etc/ntp.conf
pool master
EOF
sudo service ntp restart

sudo kubeadm join --discovery-token-unsafe-skip-ca-verification --token 8c5adc.1cec8dbf339093f0 192.168.0.10:6443 || true

sudo apt-get install nfs-common -y
sudo mkdir /dockerdata-nfs
sudo chmod 777 /dockerdata-nfs
sudo mount master:/dockerdata-nfs /dockerdata-nfs
