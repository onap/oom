#!/bin/bash

kubectl replace configmaps devsdnc-sdnc-bin -f /upgrade/reconfigure-odl-cluster-script.sh
kubectl create -f /upgrade/create-statefulset.yml
MY_REPLICA_NUMBER=$(kubectl get statefulsets {{ include "common.fullname" . }}-backup -n onap | grep "/"| awk '{print $2}')
echo "The current status of the sdnc is $MY_REPLICA_NUMBER"
while [[ ! $MY_REPLICA_NUMBER == "1/1" ]]
do
  echo "The cluster is not active yet. Please wait ..."
  MY_REPLICA_NUMBER=$(kubectl get statefulsets {{ include "common.fullname" . }}-backup -n onap | grep "/"| awk '{print $2}')
  echo "The current status of the cluster is $MY_REPLICA_NUMBER"
  sleep 2
  if [[ $MY_REPLICA_NUMBER == "1/1" ]]
  then
    break
  fi
done
kubectl scale statefulsets {{ include "common.fullname" . }} --replicas=0
kubectl delete pvc -n onap {{ include "common.fullname" . }}-mdsal-{{ include "common.fullname" . }}-0