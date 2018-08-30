#!/bin/bash

set -ex

kubectl create clusterrolebinding --user system:serviceaccount:kube-system:default kube-system-cluster-admin --clusterrole cluster-admin
wget https://storage.googleapis.com/kubernetes-helm/helm-v2.8.2-linux-amd64.tar.gz
tar xzvf helm-v2.8.2-linux-amd64.tar.gz
sudo mv linux-amd64/helm /usr/local/bin/
helm init
helm serve &
helm repo remove stable
helm repo add local http://127.0.0.1:8879

git clone -b beijing http://gerrit.onap.org/r/oom
cd oom/kubernetes

sudo apt-get install make -y
make all
sleep 300
helm install local/onap -n dev --namespace onap
