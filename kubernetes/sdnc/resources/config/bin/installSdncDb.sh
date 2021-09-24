#!/bin/sh

{{/*
###
# ============LICENSE_START=======================================================
# ONAP : SDN-C
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights reserved.
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

SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
ETC_DIR=${ETC_DIR:-${SDNC_HOME}/data}
BIN_DIR=${BIN_DIR-${SDNC_HOME}/bin}
MYSQL_HOST=${MYSQL_HOST:-dbhost}
MYSQL_PASSWORD=${MYSQL_ROOT_PASSWORD}

SDNC_DB_USER=${SDNC_DB_USER}
SDNC_DB_PASSWORD=${SDNC_DB_PASSWORD}
SDNC_DB_DATABASE=${SDNC_DB_DATABASE}


# Create tablespace and user account
mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} mysql <<-END
CREATE DATABASE IF NOT EXISTS ${SDNC_DB_DATABASE};
CREATE USER IF NOT EXISTS '${SDNC_DB_USER}'@'localhost' IDENTIFIED BY '${SDNC_DB_PASSWORD}';
CREATE USER IF NOT EXISTS '${SDNC_DB_USER}'@'%' IDENTIFIED BY '${SDNC_DB_PASSWORD}';
GRANT ALL PRIVILEGES ON ${SDNC_DB_DATABASE}.* TO '${SDNC_DB_USER}'@'localhost' WITH GRANT OPTION;
GRANT ALL PRIVILEGES ON ${SDNC_DB_DATABASE}.* TO '${SDNC_DB_USER}'@'%' WITH GRANT OPTION;
flush privileges;
commit;
END

# load schema
if [ -f ${ETC_DIR}/sdnctl.dump ]
then
  mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} ${SDNC_DB_DATABASE} < ${ETC_DIR}/sdnctl.dump
fi

for datafile in ${ETC_DIR}/*.data.dump
do
  mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWORD} ${SDNC_DB_DATABASE} < $datafile
done

# Create VNIs 100-199
${BIN_DIR}/addVnis.sh 100 199

# Drop FK_NETWORK_MODEL foreign key as workaround for SDNC-291.
${BIN_DIR}/rmForeignKey.sh NETWORK_MODEL FK_NETWORK_MODEL

if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
then
    echo "Installing directed graphs"
    ${SDNC_HOME}/svclogic/bin/install.sh
fi


exit 0
