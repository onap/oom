#!/bin/bash

set -ex

cat << EOF | sudo tee /etc/hosts
127.0.0.1    localhost
192.168.0.10 master
192.168.0.21 worker1
192.168.0.22 worker2
192.168.0.23 worker3
192.168.0.24 worker4
EOF

sudo ifconfig eth1 mtu 1400

sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
sudo apt-key adv -k 58118E89F3A912897C070ADBF76221572C52609D
cat << EOF | sudo tee /etc/apt/sources.list.d/docker.list
deb [arch=amd64] https://apt.dockerproject.org/repo ubuntu-xenial main
EOF

curl -s http://packages.cloud.google.com/apt/doc/apt-key.gpg | sudo apt-key add -
cat <<EOF | sudo tee /etc/apt/sources.list.d/kubernetes.list
deb http://apt.kubernetes.io/ kubernetes-xenial main
EOF
sudo apt-get update
sudo apt-get install -y --allow-unauthenticated --allow-downgrades docker-engine=1.12.6-0~ubuntu-xenial kubelet=1.9.1-00 kubeadm=1.9.1-00 kubectl=1.9.1-00 kubernetes-cni=0.6.0-00

cat << EOF | sudo tee /etc/docker/daemon.json
{
    "insecure-registries" : [ "nexus3.onap.org:10001" ]
}
EOF
sudo systemctl daemon-reload
sudo systemctl restart docker

sudo swapoff -a
sudo systemctl daemon-reload
sudo systemctl stop kubelet
sudo systemctl start kubelet
