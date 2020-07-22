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

#Fetch environment variables from temporary upgrade PG pod
PGPRIMARY=$(kubectl get pod -n $NAMESPACE_ENV \
  --selector name={{ .Values.service.name }}-primary -o jsonpath='{.items..metadata.name}')
echo "PGPRIMARY POD = ${PGPRIMARY}"
PGREPLICA=$(kubectl get pod -n $NAMESPACE_ENV \
  --selector name={{ .Values.service.name }}-replica -o jsonpath='{.items..metadata.name}')
echo "PGREPLICA POD = ${PGREPLICA}"
PGUPGRADE=$(kubectl get pod -n $NAMESPACE_ENV \
  --selector name={{ .Values.service.name }}-upgrade -o jsonpath='{.items..metadata.name}')
echo "PGUPGRADE POD = ${PGUPGRADE}"
PG_USER=$(kubectl exec ${PGUPGRADE} -- bash -c "printenv PG_USER")
echo "PG_USER = ${PG_USER}"
DBNAME=$(kubectl exec ${PGUPGRADE} -- bash -c "printenv PG_DATABASE")
echo "DBNAME = ${DBNAME}"

#Backup database from temporary upgrade PG pod
kubectl exec ${PGUPGRADE} -n $NAMESPACE_ENV -- pg_dump ${DBNAME} > pg_primary_dump.sql

#Wait until Frankfurt PG Primary pod is ready
PSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV ${PGPRIMARY} -- bash \
  -c "/usr/pgsql-10/bin/pg_isready -U ${PG_USER}")

while [[ ! $PSQL_STATUS == "/tmp:5432 - accepting connections" ]]
do
  echo "Postgresql upgrade deployment is not ready yet for Primary PG."
  sleep 2
  PSQL_STATUS=$(kubectl exec -n $NAMESPACE_ENV ${PGPRIMARY} -- bash \
  -c "/usr/pgsql-10/bin/pg_isready -U ${PG_USER}")
  if [[ $PSQL_STATUS == "/tmp:5432 - accepting connections" ]]
  then
    echo "Postgresql upgrade deployment is ready for Primary PG."
    DB_EXIST=$(kubectl exec -n $NAMESPACE_ENV ${PGPRIMARY} -- bash -c "psql -l |grep ${DBNAME}| wc -l")
    while [[ $DB_EXIST == 0 ]]
    do
      DB_EXIST=$(kubectl exec -n $NAMESPACE_ENV ${PGPRIMARY} -- bash -c "psql -l |grep ${DBNAME}| wc -l")
      echo "$DBNAME is not ready yet."
    done
  fi
done

#Restore database to Frankfurt PG Primary Pod
kubectl cp pg_primary_dump.sql $NAMESPACE_ENV/${PGPRIMARY}:/pgdata/
kubectl exec ${PGPRIMARY} -n $NAMESPACE_ENV -- bash -c "psql ${DBNAME} < /pgdata/pg_primary_dump.sql"
echo "Postgresql backup is restored to Primary PG."

#Delete temporary upgrade PG POD secrets and deployment
kubectl delete secrets -n $NAMESPACE_ENV {{ include "common.fullname" . }}-temp-upgrade-usercred
kubectl delete deployment -n $NAMESPACE_ENV {{ include "common.fullname" . }}-upgrade-deployment
