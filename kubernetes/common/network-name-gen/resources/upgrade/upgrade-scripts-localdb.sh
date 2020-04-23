#!/bin/bash

kubectl create -f /upgrade/create-deployment.yml
MY_REPLICA_NUMBER=$(kubectl get deployment \
  {{ include "common.fullname" . }}-backup -n $NAMESPACE_ENV \
  -o jsonpath='{.status.replicas}')

echo "The current network name gen has $MY_REPLICA_NUMBER replicas."

while [[ ! $MY_REPLICA_NUMBER == "1" ]]
do
  echo "The cluster is not active yet. Please wait ..."
  MY_REPLICA_NUMBER=$(kubectl get deployment \
    {{ include "common.fullname" . }}-backup -n $NAMESPACE_ENV \
    -o jsonpath='{.status.replicas}')
  echo "The current network name gen has $MY_REPLICA_NUMBER replicas."
  sleep 2
  if [[ $MY_REPLICA_NUMBER == "1" ]]
  then
    break
  fi
done

