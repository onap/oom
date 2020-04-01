#!/bin/bash

kubectl create -f /upgrade/create-deployment.yml
TEMP_POD=$(kubectl get pod -n $NAMESPACE_ENV | grep {{ include "common.fullname" . }}-upgrade-deployment | awk '{print $1}')
CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- /bin/bash -c 'mysql -h{{ $.Values.service.name }} -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS;"' | grep "wsrep_cluster_size" | awk '{print $2}')
CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- /bin/bash -c 'mysql -h{{ $.Values.service.name }} -u$MYSQL_USER  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS;"' | grep "wsrep_local_state_comment" | awk '{print $2}')
STS_REPLICA=$(kubectl get statefulsets -n $NAMESPACE_ENV --selector app="{{ include "common.fullname" . }}" -o jsonpath='{.items[0].spec.replicas}')
DEPLOYMENT_REPLICA=$(kubectl get deployment -n $NAMESPACE_ENV --selector app="{{ include "common.fullname" . }}" -o jsonpath='{.items[0].spec.replicas}')
while [[ ! $CLUSTER_NO == $((STS_REPLICA+DEPLOYMENT_REPLICA)) ]] || [[ ! $CLUSTER_STATE == "Synced" ]]
do
    echo "$CLUSTER_NO and $CLUSTER_STATE"
    CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- /bin/bash -c 'mysql -h{{ $.Values.service.name }} -u$MYSQL_USER -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS;"' | grep "wsrep_cluster_size" | awk '{print $2}')
    CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- /bin/bash -c 'mysql -h{{ $.Values.service.name }} -u$MYSQL_USER  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS;"' | grep "wsrep_local_state_comment" | awk '{print $2}')
    sleep 2
    if [[ $CLUSTER_NO == $((STS_REPLICA+DEPLOYMENT_REPLICA)) ]] && [[ $CLUSTER_STATE == "Synced" ]]
    then
        echo "The cluster is properly configured with $CLUSTER_NO members and in $CLUSTER_STATE state."
        break
    fi
done

sleep 2
kubectl scale statefulsets {{ include "common.fullname" . }} --replicas=0
MY_REPLICA_NUMBER=$(kubectl get statefulsets {{ include "common.fullname" . }} -n $NAMESPACE_ENV | grep "/"| awk '{print $2}')
echo "The the cluster has $MY_REPLICA_NUMBER replicas."

while [[ ! $MY_REPLICA_NUMBER == "0/0" ]]
do
    echo "The cluster is not scaled to 0 yet. Please wait ..."
    MY_REPLICA_NUMBER=$(kubectl get statefulsets {{ include "common.fullname" . }} -n $NAMESPACE_ENV |grep "/"| awk '{print $2}')
    echo "The current status of the cluster is $MY_REPLICA_NUMBER"
    kubectl get deployment -n onap --selector app=devdatabase-mariadb-galera -o jsonpath='{.items[0].status.readyReplicas}'
    sleep 2
    if [[ $MY_REPLICA_NUMBER == "0/0" ]]
    then
        break
    fi
done

for (( index=0; index<$STS_REPLICA; index+=1 ))
do
    kubectl delete pvc "{{ include "common.fullname" . }}-data-{{ include "common.fullname" . }}-$index"
done