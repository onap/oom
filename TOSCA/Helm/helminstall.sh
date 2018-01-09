#!/bin/bash
printf "%s" "$*"
printf `pwd`
printf "%s" "---------------"
kubectl create namespace onap-$2
kubectl create clusterrolebinding onap-$2-admin-binding --clusterrole=cluster-admin --serviceaccount=onap-$2:default
kubectl --namespace onap-$2 create secret docker-registry onap-docker-registry-key --docker-server=nexus3.onap.org:10001 --docker-username=docker --docker-password=docker --docker-email=@
helm install ..//$2/ --name onap-$2 --namespace onap --set nsPrefix=onap,nodePortPrefix=302
