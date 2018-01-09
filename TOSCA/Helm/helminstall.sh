#!/bin/bash
printf "%s" "$*"
printf `pwd`
printf "%s" "---------------"
kubectl create namespace $1-$2
kubectl create clusterrolebinding $1-$2-admin-binding --clusterrole=cluster-admin --serviceaccount=$1-$2:default
# assign default auth token
if [[ -z $ONAP_DEFAULT_AUTH_TOKEN ]]; then
  DEFAULT_SECRET=`kubectl get secrets -n $1-$2 | grep default-token |  awk '{ print $1}'`
  ONAP_DEFAULT_AUTH_TOKEN=`kubectl get secrets $DEFAULT_SECRET -n $1-$2 -o yaml | grep  'token:'  | awk '{ print $2}' | base64 -d`
fi
kubectl --namespace $1-$2 create secret docker-registry $1-docker-registry-key --docker-server=nexus3.onap.org:10001 --docker-username=docker --docker-password=docker --docker-email=@
helm install ..//$2/ --name $1-$2 --namespace $1 --set nsPrefix=$1,nodePortPrefix=302,kubeMasterAuthToken=$ONAP_DEFAULT_AUTH_TOKEN