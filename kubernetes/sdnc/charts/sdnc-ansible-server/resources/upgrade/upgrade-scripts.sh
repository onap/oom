#!/bin/bash

kubectl create -f /upgrade/create-deployment.yml
MY_REPLICA_NUMBER=$(kubectl get deployment {{ include "common.fullname" . }}-backup -n onap | grep "/"| awk '{print $2}')
echo "The current status of the ansible server is $MY_REPLICA_NUMBER"
while [[ ! $MY_REPLICA_NUMBER == "1/1" ]]
do
  echo "The cluster is not active yet. Please wait ..."
  MY_REPLICA_NUMBER=$(kubectl get deployment {{ include "common.fullname" . }}-backup -n onap | grep "/"| awk '{print $2}')
  echo "The current status of the cluster is $MY_REPLICA_NUMBER"
  sleep 2
  if [[ $MY_REPLICA_NUMBER == "1/1" ]]
  then
    break
  fi
done