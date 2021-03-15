#!/bin/sh
{{/*
#
# ============LICENSE_START==========================================
# ===================================================================
# Copyright © 2017 AT&T Intellectual Property. All rights reserved.
#
# ===================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END============================================
#
# ECOMP and OpenECOMP are trademarks
# and service marks of AT&T Intellectual Property.
#
*/}}

echo "Creating camundabpmn database . . ." 1>/tmp/mariadb-camundabpmn.log 2>&1

mysql -uroot -p$MYSQL_ROOT_PASSWORD << EOF || exit 1
DROP DATABASE IF EXISTS camundabpmn;
CREATE DATABASE camundabpmn;
DROP USER IF EXISTS '${CAMUNDA_DB_USER}';
CREATE USER '${CAMUNDA_DB_USER}';
GRANT ALL on camundabpmn.* to '${CAMUNDA_DB_USER}' identified by '${CAMUNDA_DB_PASSWORD}' with GRANT OPTION;
FLUSH PRIVILEGES;
EOF

cd /docker-entrypoint-initdb.d/db-sql-scripts

mysql -uroot -p$MYSQL_ROOT_PASSWORD -f < mariadb_engine_7.14.0.sql || exit 1
mysql -uroot -p$MYSQL_ROOT_PASSWORD -f < mariadb_identity_7.14.0.sql || exit 1

echo "Created camundabpmn database . . ." 1>>/tmp/mariadb-camundabpmn.log 2>&1
