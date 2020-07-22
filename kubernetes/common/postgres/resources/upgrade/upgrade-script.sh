#!/bin/bash
# Copyright © 2020 TATA Communications
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#Fetch environment variables from running PG pod
PGPOD={{ include "common.fullname" . }}-0
echo "PGPOD = {{ include "common.fullname" . }}-0"
DBNAME=$(kubectl exec ${PGPOD} -n $NAMESPACE_ENV -- bash -c "printenv PG_DATABASE")
echo "DBNAME = ${DBNAME}"
PG_PASSWORD=$(kubectl exec ${PGPOD} -n $NAMESPACE_ENV -- bash -c "printenv PG_PASSWORD")
echo "PG_PASSWORD = ${PG_PASSWORD}"
PG_PRIMARY_PASSWORD=$(kubectl exec ${PGPOD} -n $NAMESPACE_ENV -- bash -c "printenv PG_PRIMARY_PASSWORD")
echo "PG_PRIMARY_PASSWORD = ${PG_PRIMARY_PASSWORD}"
PG_ROOT_PASSWORD=$(kubectl exec ${PGPOD} -n $NAMESPACE_ENV -- bash -c "printenv PG_ROOT_PASSWORD")
echo "PG_ROOT_PASSWORD = ${PG_ROOT_PASSWORD}"
PG_USER=$(kubectl exec ${PGPOD} -n $NAMESPACE_ENV -- bash -c "printenv PG_USER")
echo "PG_USER = ${PG_USER}"
PGREPLICA=$(kubectl get statefulsets -n $NAMESPACE_ENV \
  {{ include "common.fullname" . }} -o jsonpath='{.status.replicas}')
echo "PG_REPLICA = ${PGREPLICA}"

#Create temporary secret for temporary PG pod
kubectl create secret generic \
  '{{ include "common.fullname" . }}'-temp-upgrade-usercred \
  --from-literal=PG_PASSWORD_INPUT=$PG_PASSWORD --from-literal=PG_PRIMARY_PASSWORD_INPUT=$PG_PRIMARY_PASSWORD --from-literal=PG_ROOT_PASSWORD_INPUT=$PG_ROOT_PASSWORD \
  --from-literal=PG_DATABASE=$DBNAME --from-literal=PG_USER=$PG_USER --from-literal=PG_PASSWORD=$PG_PASSWORD --from-literal=PG_ROOT_PASSWORD=$PG_ROOT_PASSWORD

#Backup databse from running postgresql pod
kubectl exec ${PGPOD} -n $NAMESPACE_ENV -- pg_dump ${DBNAME} > pg_primary_dump.sql

#Create temporary PG POD
kubectl create -f /upgrade-config/pgdb-upgrade.yaml
PGUpgradePOD=$(kubectl get pod -n $NAMESPACE_ENV \
  --selector name={{ .Values.service.name }}-upgrade -o jsonpath='{.items..metadata.name}')
echo "PGUpgradePOD = ${PGUpgradePOD}"


#Wait until temporary PG pod is ready
PSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV ${PGUpgradePOD} -- bash \
  -c "/usr/pgsql-10/bin/pg_isready -U ${PG_USER}")

while [[ ! $PSQL_STATUS == "/tmp:5432 - accepting connections" ]]
do
  echo "Postgresql upgrade deployment is not ready yet."
  sleep 2
  PSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV ${PGUpgradePOD} -- bash \
  -c "/usr/pgsql-10/bin/pg_isready -U ${PG_USER}")
  if [[ $PSQL_STATUS == "/tmp:5432 - accepting connections" ]]
  then
    echo "Postgresql upgrade deployment is ready."
    DB_EXIST=$(kubectl exec -n $NAMESPACE_ENV ${PGUpgradePOD} -- bash -c "psql -l |grep ${DBNAME}| wc -l")
    while [[ $DB_EXIST == 0 ]]
    do
      DB_EXIST=$(kubectl exec -n $NAMESPACE_ENV ${PGUpgradePOD} -- bash -c "psql -l |grep ${DBNAME}| wc -l")
      echo "$DBNAME is not ready yet."
    done
  fi
done

#Restore backup data to temporary PG pod
kubectl cp pg_primary_dump.sql $NAMESPACE_ENV/${PGUpgradePOD}:/pgdata/
kubectl exec ${PGUpgradePOD} -n $NAMESPACE_ENV -- bash -c "psql ${DBNAME} < /pgdata/pg_primary_dump.sql"

#Delete running PG pod
kubectl delete statefulset -n $NAMESPACE_ENV {{ include "common.fullname" . }} --grace-period=0 --force

#Delete PG PersistentVolumeClaims
for (( index=0; index<$PGREPLICA; index+=1 ))
do
    kubectl delete pvc -n $NAMESPACE_ENV \
    '{{ include "common.fullname" . }}'-data-'{{ include "common.fullname" . }}'-$index \
    --grace-period=0 --force
done
