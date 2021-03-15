#!/bin/bash

TEMP_POD=$(kubectl get pod -n $NAMESPACE_ENV --selector \
  app='{{ include "common.fullname" . }}' -o \
  jsonpath='{.items[?(@.metadata.ownerReferences[].kind=="ReplicaSet")].metadata.name}')

tmp_MYSQL_PASSWORD=$(echo -n $(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv \
  MYSQL_PASSWORD) | base64)

tmp_ROOT_PASSWORD=$(echo -n $(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv \
  MYSQL_ROOT_PASSWORD) | base64)

FLAG_EX_ROOT_SEC='{{ include "common.secret.getSecretNameFast" (dict "global" . "uid" (include "common.mariadb.secret.rootPassUID" .)) }}'

FLAG_EX_SEC='{{ include "common.secret.getSecretNameFast" (dict "global" . "uid" (include "common.mariadb.secret.userCredentialsUID" .)) }}'

kubectl patch secret $FLAG_EX_ROOT_SEC -p \
  '{"data":{"password":"'"$tmp_ROOT_PASSWORD"'"}}'

kubectl patch secret $FLAG_EX_SEC -p \
  '{"data":{"password":"'"$tmp_MYSQL_PASSWORD"'"}}'

MYSQL_USER=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv MYSQL_USER)

MYSQL_PASSWORD=$(echo -n $(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv MYSQL_PASSWORD))

MYSQL_ROOT_PASSWORD=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv MYSQL_ROOT_PASSWORD)

CURRENT_STS_REPLICA=$(kubectl get statefulsets -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')

DEPLOYMENT_REPLICA=$(kubectl get deployment -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }}-upgrade-deployment -o \
  jsonpath='{.status.replicas}')

if [[ $CURRENT_STS_REPLICA == "0" ]]
then
  echo "Seems there was no upgrade of cluster and we will scale up cluster replicas back to $REPLICA_COUNT now"
  kubectl scale statefulsets {{ include "common.fullname" . }} --replicas=$REPLICA_COUNT
fi

MY_REPLICA_NUMBER=$(kubectl get statefulsets -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')

while [[ ! $MY_REPLICA_NUMBER == $REPLICA_COUNT ]]
do
    echo "The cluster is not scaled up to $REPLICA_COUNT yet. Please wait ..."
    MY_REPLICA_NUMBER=$(kubectl get statefulsets -n $NAMESPACE_ENV \
      {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')
    echo "The current status of the cluster is $MY_REPLICA_NUMBER"
    sleep 2
    if [[ $MY_REPLICA_NUMBER == $REPLICA_COUNT ]]
    then
        break
    fi
done

CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- \
  mysql --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" | \
  awk '{print $2}')

CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- \
  mysql --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_local_state_comment';" \
  | awk '{print $2}')

while [[ ! $CLUSTER_NO == $((REPLICA_COUNT+DEPLOYMENT_REPLICA)) ]] \
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
    if [[ $CLUSTER_NO == $((REPLICA_COUNT+DEPLOYMENT_REPLICA)) ]] \
       && [[ $CLUSTER_STATE == "Synced" ]]
    then
        echo "The cluster has $CLUSTER_NO members and  $CLUSTER_STATE state."
        break
    fi
done

MYSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 -- mysqladmin \
  -uroot -p$MYSQL_ROOT_PASSWORD ping)

while [[ ! $MYSQL_STATUS == "mysqld is alive" ]]
do
  echo "Mariadb deployment is not ready yet."
  sleep 2
  MYSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 -- mysqladmin \
  -uroot -p$MYSQL_ROOT_PASSWORD ping)
  if [[ $MYSQL_STATUS == "mysqld is alive" ]]
  then
    echo "Mariadb deployment is ready and cluster size is $CLUSTER_NO"
    break
  fi
done

echo "Deleting upgrade deployment now"

kubectl delete deployment -n $NAMESPACE_ENV {{ include "common.fullname" . }}-upgrade-deployment
kubectl delete secret -n $NAMESPACE_ENV {{ include "common.fullname" . }}-temp-upgrade-root
kubectl delete secret -n $NAMESPACE_ENV {{ include "common.fullname" . }}-temp-upgrade-usercred

CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 -- \
  mysql --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" | \
  awk '{print $2}')

CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 -- \
  mysql --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
  -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_local_state_comment';" \
  | awk '{print $2}')

while [[ ! $CLUSTER_NO == $REPLICA_COUNT ]] \
   || [[ ! $CLUSTER_STATE == "Synced" ]]
do
    echo "$CLUSTER_NO and $CLUSTER_STATE"
    CLUSTER_NO=$(kubectl exec -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 -- mysql \
      --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
      -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_cluster_size';" \
      | awk '{print $2}')
    CLUSTER_STATE=$(kubectl exec -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 -- mysql \
      --skip-column-names -h{{ $.Values.service.name }} -u$MYSQL_USER \
      -p$MYSQL_PASSWORD -e "SHOW GLOBAL STATUS LIKE 'wsrep_local_state_comment';" \
      | awk '{print $2}')
    sleep 2
    if [[ $CLUSTER_NO == $REPLICA_COUNT ]] \
       && [[ $CLUSTER_STATE == "Synced" ]]
    then
        echo "The cluster has $CLUSTER_NO members and  $CLUSTER_STATE state."
        break
    fi
done

echo "The cluster upgrade is finished now"
