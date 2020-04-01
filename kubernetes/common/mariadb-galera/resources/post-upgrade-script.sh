#!/bin/bash

TEMP_POD=$(kubectl get pod -n $NAMESPACE_ENV --selector \
  app='{{ include "common.fullname" . }}' -o \
  jsonpath='{.items[?(@.metadata.ownerReferences[].kind=="ReplicaSet")].metadata.name}')

tmp_MYSQL_USER=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv \
   MYSQL_USER | base64)

tmp_MYSQL_PASSWORD=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv \
   MYSQL_PASSWORD | base64)

tmp_ROOT_PASSWORD=$(kubectl exec -n $NAMESPACE_ENV $TEMP_POD -- printenv \
   MYSQL_ROOT_PASSWORD | base64)

FLAG_EX_ROOT_SEC='{{ tpl (index .Values.secrets 0).externalSecret . }}'

FLAG_EX_SEC='{{ tpl (index .Values.secrets 1).externalSecret . }}'

if [[ ! $FLAG_EX_ROOT_SEC == "" ]]
then
  kubectl patch secret $FLAG_EX_ROOT_SEC -p \
    '{"data":{"password":'"$tmp_ROOT_PASSWORD"'}}'
else
  kubectl patch secret {{ include "common.fullname" . }}-db-root-password \
    -p '{"data":{"password":'"$tmp_ROOT_PASSWORD"'}}'
fi

if [[ ! $FLAG_EX_SEC == "" ]]
then
  kubectl patch secret $FLAG_EX_SEC -p \
    '{"data":{"password":'"$tmp_MYSQL_PASSWORD"'}}'
else
  kubectl patch secret {{ include "common.fullname" . }}-db-user-credentials \
    -p '{"data":{"password":'"$tmp_MYSQL_PASSWORD"'}}'
fi

kubectl delete pod -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 --now
