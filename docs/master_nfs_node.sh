#!/bin/sh

usage () {
  echo "Usage:"
  echo "   ./$(basename $0) node1_ip node2_ip ... nodeN_ip"
  exit 1
}

if [ "$#" -lt 1 ]; then
  echo "Missing NFS slave nodes"
  usage
fi

#Install NFS kernel
sudo apt-get update
sudo apt-get install -y nfs-kernel-server

#Create /dockerdata-nfs and set permissions
sudo mkdir -p /dockerdata-nfs
sudo chmod 777 -R /dockerdata-nfs
sudo chown nobody:nogroup /dockerdata-nfs/

#Update the /etc/exports
NFS_EXP=""
for i in $@; do
  NFS_EXP="${NFS_EXP}$i(rw,sync,no_root_squash,no_subtree_check) "
done
echo "/dockerdata-nfs "$NFS_EXP | sudo tee -a /etc/exports

#Restart the NFS service
sudo exportfs -a
sudo systemctl restart nfs-kernel-server
