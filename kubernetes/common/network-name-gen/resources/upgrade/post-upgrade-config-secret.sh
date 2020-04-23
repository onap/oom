#!/bin/bash
set -e
NENGPWD_OLD=$(kubectl get secret \
  '{{ include "common.release" . }}-tmp-neng-secret' \
  -o jsonpath='{.data.password}')
kubectl patch secret {{ include "common.release" . }}-neng-db-secret -p \
  '{"data":{"password":"'"$NENGPWD_OLD"'"}}'