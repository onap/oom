#!/bin/bash
NENGPWD_OLD=$(kubectl get secret \
  '{{ include "common.release" . }}-tmp-neng-secret' \
  -o jsonpath='{.data.password}')
kubectl get secret {{ include "common.release" . }}-neng-db-secret -o \
    yaml | sed 's/password\: *.*/password\: '"$NENGPWD_OLD"'/' \
    | kubectl apply -f -
sleep 1