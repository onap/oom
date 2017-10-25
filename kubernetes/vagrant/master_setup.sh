#!/bin/bash

sudo kubeadm init --apiserver-advertise-address 192.168.1.10  --service-cidr=192.168.1.0/24 --pod-network-cidr=10.244.0.0/16 --token 8c5adc.1cec8dbf339093f0
sudo cp /etc/kubernetes/admin.conf $HOME/
sudo chown $(id -u):$(id -g) $HOME/admin.conf
cp $HOME/admin.conf /vagrant
export KUBECONFIG=$HOME/admin.conf
echo "export KUBECONFIG=$HOME/admin.conf" >> $HOME/.bash_profile
kubectl apply -f http://git.io/weave-kube-1.6

curl https://raw.githubusercontent.com/kubernetes/helm/master/scripts/get | bash
helm init
kubectl create clusterrolebinding --user system:serviceaccount:kube-system:default kube-system-cluster-admin --clusterrole cluster-admin
