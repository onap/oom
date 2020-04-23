#!/bin/bash

TMP_POD=$(kubectl get pod -n $NAMESPACE_ENV \
  | grep mariadb-galera-0 | awk '{print $1}')

MYSQL_ROOT_PWD=$(kubectl exec -n $NAMESPACE_ENV \
  $TMP_POD -- printenv MYSQL_ROOT_PASSWORD)

TMP_FLAG=$(kubectl get secret '{{ include "common.fullname" . }}-db-root-password')

if [[ $TMP_FLAG == "" ]]
then
  kubectl create secret generic \
    '{{ include "common.fullname" . }}-db-root-password' \
    --from-literal=password=$MYSQL_ROOT_PWD
fi

