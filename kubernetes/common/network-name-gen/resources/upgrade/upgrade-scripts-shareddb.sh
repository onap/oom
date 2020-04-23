#!/bin/bash

TMP_STS=$(kubectl get statefulsets -n onap -o \
  jsonpath='{.items[?(@.spec.template.spec.containers[].name=="mariadb-galera")].metadata.name}')

MYSQL_ROOT_PWD=$(kubectl exec -n $NAMESPACE_ENV \
  $TMP_STS-0 -- printenv MYSQL_ROOT_PASSWORD)

FLAG=$(kubectl get pod -n $NAMESPACE_ENV \
  '{{ include "common.release" . }}-nengdb-0')

if [[ ! $FLAG == "" ]]
then
  NENGUSER=$(kubectl exec -n $NAMESPACE_ENV \
    '{{ include "common.release" . }}-nengdb-0' -- printenv MYSQL_USER)
  NENGPWD=$(kubectl exec -n $NAMESPACE_ENV \
    '{{ include "common.release" . }}-nengdb-0' -- printenv MYSQL_PASSWORD)
  NENGDB=$(kubectl exec -n $NAMESPACE_ENV \
    '{{ include "common.release" . }}-nengdb-0' -- printenv MYSQL_DATABASE)
  kubectl exec -n $NAMESPACE_ENV '{{ include "common.release" . }}-nengdb-0' \
    -- mysqldump -u$NENGUSER -p$NENGPWD \
    $NENGDB > /my-data/nengdb-backup.sql
  kubectl create secret generic \
    '{{ include "common.release" . }}-tmp-neng-secret' \
    --from-literal=login=$NENGUSER --from-literal=password=$NENGPWD
fi

TMP_FLAG=$(kubectl get secret '{{ include "common.fullname" . }}-db-root-password')

if [[ $TMP_FLAG == "" ]]
then
  kubectl create secret generic \
    '{{ include "common.fullname" . }}-db-root-password' \
    --from-literal=password=$MYSQL_ROOT_PWD
fi