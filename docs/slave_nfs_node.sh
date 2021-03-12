#!/bin/sh

usage () {
  echo "Usage:"
  echo "   ./$(basename $0) nfs_master_ip"
  exit 1
}

if [ "$#" -ne 1 ]; then
  echo "Missing NFS mater node"
  usage
fi

MASTER_IP=$1

#Install NFS common
sudo apt-get update
sudo apt-get install -y nfs-common

#Create NFS directory
sudo mkdir -p /dockerdata-nfs

#Mount the remote NFS directory to the local one
sudo mount $MASTER_IP:/dockerdata-nfs /dockerdata-nfs/
echo "$MASTER_IP:/dockerdata-nfs /dockerdata-nfs nfs auto,nofail,noatime,nolock,intr,tcp,actimeo=1800 0 0" | sudo tee -a /etc/fstab
