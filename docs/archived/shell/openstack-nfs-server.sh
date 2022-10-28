#!/bin/sh

apt-get update

IP_ADDR=$(ip address |grep ens|grep inet|awk '{print $2}'| awk -F / '{print $1}')
HOST_NAME=$(hostname)

echo "$IP_ADDR $HOST_NAME" >> /etc/hosts

sudo apt-get install make -y

# nfs server
sudo apt-get install nfs-kernel-server -y

sudo mkdir -p /nfs_share
sudo chown nobody:nogroup /nfs_share/

exit 0
