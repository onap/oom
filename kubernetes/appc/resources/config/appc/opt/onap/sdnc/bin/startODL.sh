#!/bin/bash

###
# ============LICENSE_START=======================================================
# openECOMP : SDN-C
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights
#                                                       reserved.
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


# Install SDN-C platform components if not already installed and start container

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-{{.Values.config.dbRootPassword}}}

#
# Wait for database
#
echo "Waiting for mysql"
until mysql -h {{.Values.mysql.service.name}}.{{.Release.Namespace}} -u root -p{{.Values.config.dbRootPassword}} mysql &> /dev/null
do
  printf "."
  sleep 1
done
echo -e "\nmysql ready"

if [ ! -f ${SDNC_HOME}/.installed ]
then
        echo "Installing SDN-C database"
        ${SDNC_HOME}/bin/installSdncDb.sh
        echo "Starting OpenDaylight"
        ${ODL_HOME}/bin/start
        echo "Waiting ${SLEEP_TIME} seconds for OpenDaylight to initialize"
        sleep ${SLEEP_TIME}
        echo "Installing SDN-C platform features"
        ${SDNC_HOME}/bin/installFeatures.sh
        if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
        then
                echo "Installing directed graphs"
                ${SDNC_HOME}/svclogic/bin/install.sh
        fi


        echo "Restarting OpenDaylight"
        ${ODL_HOME}/bin/stop
        echo "Installed at `date`" > ${SDNC_HOME}/.installed
fi

exec ${ODL_HOME}/bin/karaf

