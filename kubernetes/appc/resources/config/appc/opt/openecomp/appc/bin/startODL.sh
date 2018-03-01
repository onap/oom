#!/bin/bash

###
# ============LICENSE_START=======================================================
# APPC
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
# ECOMP is a trademark and service mark of AT&T Intellectual Property.
###

#
# This script takes care of installing the SDNC & APPC platform components
#  if not already installed, and starts the APPC Docker Container
#

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
APPC_HOME=${APPC_HOME:-/opt/openecomp/appc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-openECOMP1.0}

#
# Adding the DMAAP_TOPIC_ENV variable into APPC-ASDC-LISTENER properties
#
DMAAP_TOPIC_ENV=${DMAAP_TOPIC_ENV}

if [ -z "$DMAAP_TOPIC_ENV" ]
        then
        echo "DMAAP_TOPIC_ENV shell variable is empty. Adding default value OS-ETE-DFW"
                DMAAP_TOPIC_ENV="OS-ETE-DFW"
        else
                echo "DMAAP_TOPIC_ENV shell variable exists and it's $DMAAP_TOPIC_ENV"
fi

echo "Adding a value to property appc.asdc.env in appc.properties for appc-asdc-listener feature"
echo "" >> $APPC_HOME/data/properties/appc.properties
echo "appc.asdc.env=$DMAAP_TOPIC_ENV" >> $APPC_HOME/data/properties/appc.properties
echo "" >> $APPC_HOME/data/properties/appc.properties

#
# Wait for database to init properly
#
echo "Waiting for mysql"
until mysql -h appc-dbhost.{{.Values.nsPrefix}} -u root -p${MYSQL_PASSWD} mysql &> /dev/null
do
  printf "."
  sleep 1
done
echo -e "\nmysql ready"

if [ ! -f ${SDNC_HOME}/.installed ]
then
        echo "Installing SDNC database"
        ${SDNC_HOME}/bin/installSdncDb.sh
        echo "Installing APPC database"
        ${APPC_HOME}/bin/installAppcDb.sh
        echo "Starting OpenDaylight"
        ${ODL_HOME}/bin/start
        echo "Waiting ${SLEEP_TIME} seconds for OpenDaylight to initialize"
        sleep ${SLEEP_TIME}
        echo "Inserting modified installFeatures.sh for sdnc"
        rm ${SDNC_HOME}/bin/installFeatures.sh
        cp ${APPC_HOME}/data/sdncInstallFeatures.sh ${SDNC_HOME}/bin/installFeatures.sh
        echo "Installing SDNC platform features"
        ${SDNC_HOME}/bin/installFeatures.sh
        if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
        then
                echo "Installing directed graphs"
                ${SDNC_HOME}/svclogic/bin/install.sh
        fi

        echo "Installing APPC platform features"
        ${APPC_HOME}/bin/installFeatures.sh
        if [ -x ${APPC_HOME}/svclogic/bin/install.sh ]
        then
                echo "Installing APPC DGs using platform-logic"
                ${APPC_HOME}/svclogic/bin/install.sh
        fi

        if [ -x ${APPC_HOME}/svclogic/bin/install-converted-dgs.sh ]
        then
                echo "Installing APPC JSON DGs converted to XML using dg-loader"
                ${APPC_HOME}/svclogic/bin/install-converted-dgs.sh
        fi

        echo "Restarting OpenDaylight"
        ${ODL_HOME}/bin/stop
        echo "Installed at `date`" > ${SDNC_HOME}/.installed
fi

exec ${ODL_HOME}/bin/karaf

