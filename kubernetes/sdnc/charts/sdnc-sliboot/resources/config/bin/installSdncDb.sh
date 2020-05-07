#!/bin/bash

###
# ============LICENSE_START=======================================================
# ONAP : SDN-C
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights
# 							reserved.
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

SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
SDNC_CONFIG_DIR=${SDNC_CONFIG_DIR:-/opt/onap/sdnc/config}
MYSQL_HOST=${MYSQL_HOST:-dbhost}
MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}

SDNC_DB_USER=${SDNC_DB_USER}
SDNC_DB_PASSWORD=${SDNC_DB_PASSWORD}
SDNC_DB_DATABASE=${SDNC_DB_DATABASE}

# Wait for database
#
echo "Waiting for database"
until mysqladmin ping -h ${MYSQL_HOST} --silent
do
  printf "."
  sleep 1
done

# Create tablespace and user account
mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} mysql <<-END
CREATE DATABASE IF NOT EXISTS ${SDNC_DB_DATABASE};
drop user '${SDNC_DB_USER}'@'localhost';
flush privileges;
CREATE USER '${SDNC_DB_USER}'@'localhost' IDENTIFIED BY '${SDNC_DB_PASSWORD}';
drop user '${SDNC_DB_USER}'@'%';
flush privileges;
CREATE USER '${SDNC_DB_USER}'@'%' IDENTIFIED BY '${SDNC_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SDNC_DB_DATABASE}.* TO '${SDNC_DB_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${SDNC_DB_DATABASE}.* TO '${SDNC_DB_USER}'@'%' WITH GRANT OPTION;
flush privileges;
commit;
END

# Initialize schema 
mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} ${SDNC_DB_DATABASE} < ${SDNC_HOME}/config/schema.sql
echo -e "\nDatabase ready"

exit 0
