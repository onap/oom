#!/bin/sh

{{/*
###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
# Modifications Copyright © 2018 Amdocs,Bell Canada
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
###
*/}}

SDNC_HOME=${SDNC_HOME:-/opt/onap/ccsdk}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
MYSQL_PASSWD=${MYSQL_ROOT_PASSWORD}
MYSQL_HOST=${DB_HOST}.{{.Release.Namespace}}
MYSQL_PORT=${DB_PORT}

APPC_DB_USER=${APPC_DB_USER}
APPC_DB_PASSWD=${APPC_DB_PASSWD}
APPC_DB_DATABASE={{.Values.config.appcdb.dbName}}
SDNC_DB_DATABASE={{.Values.config.sdncdb.dbName}}


# Create tablespace and user account
mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u root -p${MYSQL_PASSWD} mysql <<-END
CREATE DATABASE ${APPC_DB_DATABASE};
CREATE USER '${APPC_DB_USER}'@'localhost' IDENTIFIED BY '${APPC_DB_PASSWD}';
CREATE USER '${APPC_DB_USER}'@'%' IDENTIFIED BY '${APPC_DB_PASSWD}';
GRANT ALL PRIVILEGES ON ${APPC_DB_DATABASE}.* TO '${APPC_DB_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${APPC_DB_DATABASE}.* TO '${APPC_DB_USER}'@'%' WITH GRANT OPTION;
commit;
END

if [ -f ${APPC_HOME}/data/appcctl.dump ]
then
  mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u root -p${MYSQL_PASSWD} ${APPC_DB_DATABASE} < ${APPC_HOME}/data/appcctl.dump
fi

if [ -f ${APPC_HOME}/data/sdnctl.dump ]
then
  mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u root -p${MYSQL_PASSWD} ${SDNC_DB_DATABASE} < ${APPC_HOME}/data/sdnctl.dump
fi

if [ -f ${APPC_HOME}/data/sqlData.dump ]
then
  mysql -h ${MYSQL_HOST} -P ${MYSQL_PORT} -u root -p${MYSQL_PASSWD} ${SDNC_DB_DATABASE} < ${APPC_HOME}/data/sqlData.dump
fi
