#!/bin/bash

TEMP_POD=$(kubectl get pod -n $NAMESPACE_ENV | grep \
   {{ include "common.fullname" . }}-upgrade-deployment | awk '{print $1}')
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
  kubectl get secret $FLAG_EX_ROOT_SEC -o \
    yaml | sed 's/password\: *.*/password\: '"$tmp_ROOT_PASSWORD"'/' \
    | kubectl apply -f -
else
  kubectl get secret {{ include "common.fullname" . }}-db-root-password -o \
    yaml | sed 's/password\: *.*/password\: '"$tmp_ROOT_PASSWORD"'/' \
    | kubectl apply -f -
fi

if [[ ! $FLAG_EX_SEC == "" ]]
then
  kubectl get secret $FLAG_EX_SEC -o \
    yaml | sed 's/password\: *.*/password\: '"$tmp_MYSQL_PASSWORD"'/' \
    | kubectl apply -f -
else
  kubectl get secret {{ include "common.fullname" . }}-db-user-credentials -o \
    yaml | sed 's/password\: *.*/password\: '"$tmp_MYSQL_PASSWORD"'/' \
    | kubectl apply -f -
fi
kubectl delete pod -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 --now