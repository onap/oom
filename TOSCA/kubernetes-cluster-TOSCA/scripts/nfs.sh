#!/bin/sh


mkdir -p /dockerdata-nfs
chmod 777 /dockerdata-nfs
yum -y install nfs-utils
systemctl enable nfs-server.service
systemctl start nfs-server.service
echo "/dockerdata-nfs *(rw,no_root_squash,no_subtree_check)" |sudo tee --append /etc/exports
echo "/home/centos/dockerdata-nfs /dockerdata-nfs    none    bind  0  0" |sudo tee --append /etc/fstab
exportfs -a