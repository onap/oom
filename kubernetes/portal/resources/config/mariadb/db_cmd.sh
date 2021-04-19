#!/bin/sh
{{/*
# Copyright © 2018 AT&T
# Copyright © 2020 Aarna Networks
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
*/}}

# Initializing parameters
DB={{index .Values.mariadb.config.dbname | upper }}
eval "MYSQL_USER=\$MYSQL_USER_${DB}"
eval "MYSQL_PASSWORD=\$MYSQL_PASSWORD_${DB}"
PORTAL_DB_TABLES={{ .Values.mariadb.config.backend_portal_tables }}

echo "INFO: Downloading DDL and DML SQL scripts\n"
cd /tmp
curl -O https://git.onap.org/portal/plain/ecomp-portal-DB-common/PortalDDLMySql_3_3_Common.sql \
     -O https://git.onap.org/portal/plain/ecomp-portal-DB-common/PortalDMLMySql_3_3_Common.sql \
     -O https://git.onap.org/portal/plain/ecomp-portal-DB-os/PortalDDLMySql_3_3_OS.sql \
     -O https://git.onap.org/portal/plain/ecomp-portal-DB-os/PortalDMLMySql_3_3_OS.sql \
     -O https://git.onap.org/portal/sdk/plain/ecomp-sdk/epsdk-app-common/db-scripts/EcompSdkDDLMySql_3_3_Common.sql \
     -O https://git.onap.org/portal/sdk/plain/ecomp-sdk/epsdk-app-common/db-scripts/EcompSdkDMLMySql_3_3_Common.sql \
     -O https://git.onap.org/portal/sdk/plain/ecomp-sdk/epsdk-app-os/db-scripts/EcompSdkDDLMySql_3_3_OS.sql \
     -O https://git.onap.org/portal/sdk/plain/ecomp-sdk/epsdk-app-os/db-scripts/EcompSdkDMLMySql_3_3_OS.sql

echo "INFO: Drop DB and run initialization scripts\n"
mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h${DB_HOST} -P${DB_PORT} -e 'DROP DATABASE portal;'
for file in *.sql;
  do
    echo "INFO: Executing $file"
    mysql -uroot -p${MYSQL_ROOT_PASSWORD} -h${DB_HOST} -P${DB_PORT} < ./$file
  done
echo
for i in $(echo $PORTAL_DB_TABLES | sed "s/,/ /g")
  do
    echo "Granting portal user ALL PRIVILEGES for table $i"
    echo "GRANT ALL ON \`$i\`.* TO '${MYSQL_USER}'@'%' ;" | mysql -vv -uroot -p${MYSQL_ROOT_PASSWORD} -h${DB_HOST} -P${DB_PORT} mysql
  done
echo "INFO: Running OnBoarding scripts and oom updates\n"
curl -O https://git.onap.org/portal/plain/deliveries/Apps_Users_OnBoarding_Script.sql
mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${DB_HOST} -P${DB_PORT} < ./Apps_Users_OnBoarding_Script.sql
mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${DB_HOST} -P${DB_PORT} < /db_config/oom_updates.sql

if [ $? -ne 0 ];then
        echo "ERROR: Failed to create and initialize DBs"
        exit 1
else
        echo "INFO: Database initialized successfully"
fi
