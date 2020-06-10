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

kubectl delete pod -n $NAMESPACE_ENV {{ include "common.fullname" . }}-0 --now
kubectl delete deployment -n $NAMESPACE_ENV {{ include "common.fullname" . }}-upgrade-deployment
kubectl delete secret -n $NAMESPACE_ENV {{ include "common.fullname" . }}-temp-upgrade-root
kubectl delete secret -n $NAMESPACE_ENV {{ include "common.fullname" . }}-temp-upgrade-usercred