#!/bin/bash
MYSQL_USER=$(kubectl exec -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }}-0 -- printenv MYSQL_USER)

MYSQL_PASSWORD=$(kubectl exec -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }}-0 -- printenv MYSQL_PASSWORD)

MYSQL_ROOT_PASSWORD=$(kubectl exec -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }}-0 -- printenv MYSQL_ROOT_PASSWORD)

kubectl create secret generic \
  '{{ include "common.fullname" . }}'-temp-upgrade-root \
  --from-literal=password=$MYSQL_ROOT_PASSWORD

kubectl create secret generic \
  '{{ include "common.fullname" . }}'-temp-upgrade-usercred \
  --from-literal=login=$MYSQL_USER --from-literal=password=$MYSQL_PASSWORD

kubectl create -f /upgrade/create-deployment.yml

TEMP_POD=$(kubectl get pod -n $NAMESPACE_ENV --selector \
  app='{{ include "common.fullname" . }}' -o \
  jsonpath='{.items[?(@.metadata.ownerReferences[].kind=="ReplicaSet")].metadata.name}')

CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- \
  mysql --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" | \
  awk '{print $2}')

CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- \
  mysql --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_local_state_comment';" \
  | awk '{print $2}')

STS_REPLICA=$(kubectl get statefulsets -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')

DEPLOYMENT_REPLICA=$(kubectl get deployment -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }}-upgrade-deployment -o \
  jsonpath='{.status.replicas}')

while [[ ! $CLUSTER_NO == $((STS_REPLICA+DEPLOYMENT_REPLICA)) ]] \
   || [[ ! $CLUSTER_STATE == "Synced" ]]
do
    echo "$CLUSTER_NO and $CLUSTER_STATE"
    CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- mysql \
      --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
      -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" \
      | awk '{print $2}')
    CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- mysql \
      --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
      -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_local_state_comment';" \
      | awk '{print $2}')
    sleep 2
    if [[ $CLUSTER_NO == $((STS_REPLICA+DEPLOYMENT_REPLICA)) ]] \
       && [[ $CLUSTER_STATE == "Synced" ]]
    then
        echo "The cluster has $CLUSTER_NO members and  $CLUSTER_STATE state."
        break
    fi
done

MYSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- mysqladmin \
  -uroot -p$MYSQL_ROOT_PASSWORD ping)

while [[ ! $MYSQL_STATUS == "mysqld is alive" ]]
do
  echo "Mariadb deployment is not ready yet."
  sleep 2
  MYSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- mysqladmin \
  -uroot -p$MYSQL_ROOT_PASSWORD ping)
  if [[ $MYSQL_STATUS == "mysqld is alive" ]]
  then
    echo "Mariadb deployment is ready."
    break
  fi
done

kubectl scale statefulsets {{ include "common.fullname" . }} --replicas=0
MY_REPLICA_NUMBER=$(kubectl get statefulsets -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')
echo "The the cluster has $MY_REPLICA_NUMBER replicas."

while [[ ! $MY_REPLICA_NUMBER == "0" ]]
do
    echo "The cluster is not scaled to 0 yet. Please wait ..."
    MY_REPLICA_NUMBER=$(kubectl get statefulsets -n $NAMESPACE_ENV \
      {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')
    echo "The current status of the cluster is $MY_REPLICA_NUMBER"
    sleep 2
    if [[ $MY_REPLICA_NUMBER == "0" ]]
    then
        break
    fi
done

for (( index=0; index<$STS_REPLICA; index+=1 ))
do
    kubectl delete pvc \
    "{{ include "common.fullname" . }}-data-{{ include "common.fullname" . }}-$index"
done
