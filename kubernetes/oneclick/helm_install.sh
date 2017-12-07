#!/bin/bash
display_usage() { 
    echo "./helm_install.sh <namespace> <app-name>"
}
 

if [  $# -le 1 ] 
then 
  display_usage
  exit 1
fi 
 
if [[ ( $# == "--help") ||  $# == "-h" ]] 
then 
 display_usage
 exit 0
fi 
 
kubectl create namespace $1-$2
kubectl create clusterrolebinding $1-$2-admin-binding --clusterrole=cluster-admin --serviceaccount=$1-$2:default
kubectl --namespace $1-$2 create secret docker-registry onap-docker-registry-key --docker-server=nexus3.onap.org:10001 --docker-username=docker --docker-password=docker --docker-email=@
helm install ../mso --name $1-$2 --namespace $1-$2 --set nsPrefix=$1,nodePortPrefix=302 
