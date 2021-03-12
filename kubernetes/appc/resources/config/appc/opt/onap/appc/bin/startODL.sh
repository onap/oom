#!/bin/sh -x

{{/*
###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2017-2019 AT&T Intellectual Property. All rights reserved.
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
# ECOMP is a trademark and service mark of AT&T Intellectual Property.
###

#
# This script takes care of installing the SDNC & APPC platform components
#  if not already installed, and starts the APPC Docker Container
#
#set -x
*/}}

enable_odl_cluster () {
  if [ -z $APPC_REPLICAS ]; then
     echo "APPC_REPLICAS is not configured in Env field"
     exit
  fi

  echo "Update cluster information statically"
  hm=$(hostname)
  echo "Get current Hostname ${hm}"

  node=($(echo ${hm} | sed 's/-[0-9]*$//g'))
  node_index=($(echo ${hm} | awk -F"-" '{print $NF}'))
  node_list="${node}-0.{{ .Values.service.name }}-cluster.{{.Release.Namespace}}";

  for i in $(seq 1 $((${APPC_REPLICAS}-1)));
  do
    node_list="${node_list} ${node}-$i.{{ .Values.service.name }}-cluster.{{.Release.Namespace}}"
  done

  /opt/opendaylight/current/bin/configure_cluster.sh $((node_index+1)) ${node_list}
}

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
SDNC_HOME=${SDNC_HOME:-/opt/onap/ccsdk}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_ROOT_PASSWORD}
ENABLE_ODL_CLUSTER=${ENABLE_ODL_CLUSTER:-false}
ENABLE_AAF=${ENABLE_AAF:-true}
DBINIT_DIR=${DBINIT_DIR:-/opt/opendaylight/current/daexim}

#
# Wait for database to init properly
#
echo "Waiting for mariadbgalera"
until mysql -h {{.Values.config.mariadbGaleraSVCName}}.{{.Release.Namespace}} -u root -p${MYSQL_PASSWD}  mysql >/dev/null 2>&1
do
  printf "."
  sleep 1
done
echo
echo "mariadbgalera ready"

if [ ! -d ${DBINIT_DIR} ]
then
    mkdir -p ${DBINIT_DIR}
fi

if [ ! -f ${DBINIT_DIR}/.installed ]
then
        sdnc_db_exists=$(mysql -h {{.Values.config.mariadbGaleraSVCName}}.{{.Release.Namespace}} -u root -p${MYSQL_PASSWD} mysql <<-END
show databases like 'sdnctl';
END
)
        if [ "${sdnc_db_exists}" = "" ]
        then
            echo "Installing SDNC database"
            ${SDNC_HOME}/bin/installSdncDb.sh

            appc_db_exists=$(mysql -h {{.Values.config.mariadbGaleraSVCName}}.{{.Release.Namespace}} -u root -p${MYSQL_PASSWD} mysql <<-END
show databases like 'appcctl';
END
)
            if [ "${appc_db_exists}" = "" ]
            then
              echo "Installing APPC database"
              ${APPC_HOME}/bin/installAppcDb.sh
            fi
        else
            sleep 30
        fi

        echo "Installed at `date`" > ${DBINIT_DIR}/.installed
fi


if [ ! -f ${SDNC_HOME}/.installed ]
then
        echo "Installing ODL Host Key"
        ${SDNC_HOME}/bin/installOdlHostKey.sh

#        echo "Copying a working version of the logging configuration into the opendaylight etc folder"
#        cp ${APPC_HOME}/data/org.ops4j.pax.logging.cfg ${ODL_HOME}/etc/org.ops4j.pax.logging.cfg


        echo "Waiting ${SLEEP_TIME} seconds for OpenDaylight to initialize"
        sleep ${SLEEP_TIME}


        if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
        then
                echo "Installing directed graphs"
                ${SDNC_HOME}/svclogic/bin/install.sh
        fi

        if [ -x ${APPC_HOME}/svclogic/bin/install-converted-dgs.sh ]
        then
                echo "Installing APPC JSON DGs converted to XML using dg-loader"
                ${APPC_HOME}/svclogic/bin/install-converted-dgs.sh
        fi

        if $ENABLE_ODL_CLUSTER
        then
                echo "Enabling Opendaylight cluster features"
                enable_odl_cluster
        fi

        echo "Copying the aaa shiro configuration into opendaylight"
        mkdir -p ${ODL_HOME}/etc/opendaylight/datastore/initial/config
        if $ENABLE_AAF
        then
             cp ${APPC_HOME}/data/properties/aaa-app-config.xml ${ODL_HOME}/etc/opendaylight/datastore/initial/config/aaa-app-config.xml
        fi

fi

# Move journal and snapshots directory to persistent storage

hostdir=${ODL_HOME}/daexim/$(hostname -s)
if [ ! -d $hostdir ]
then
    mkdir -p $hostdir
    if [ -d ${ODL_HOME}/journal ]
    then
        mv ${ODL_HOME}/journal ${hostdir}
    else
        mkdir ${hostdir}/journal
    fi
    if [ -d ${ODL_HOME}/snapshots ]
    then
        mv ${ODL_HOME}/snapshots ${hostdir}
    else
        mkdir ${hostdir}/snapshots
    fi
fi

ln -s ${hostdir}/journal ${ODL_HOME}/journal
ln -s ${hostdir}/snapshots ${ODL_HOME}/snapshots

echo "Starting cdt-proxy-service jar, logging to ${APPC_HOME}/cdt-proxy-service/jar.log"
java -jar ${APPC_HOME}/cdt-proxy-service/cdt-proxy-service.jar > ${APPC_HOME}/cdt-proxy-service/jar.log &

echo "Starting dmaap-event-service jar, logging to ${APPC_HOME}/dmaap-event-service/jar.log"
java -jar -Dorg_onap_appc_bootstrap_path=/opt/onap/appc/data/properties -Dorg_onap_appc_bootstrap_file=appc.properties ${APPC_HOME}/dmaap-event-service/dmaap-event-service.jar > ${APPC_HOME}/dmaap-event-service/jar.log &

echo "Adding a property system.properties for AAF cadi.properties location"
echo "" >> ${ODL_HOME}/etc/system.properties
echo "cadi_prop_files=${APPC_HOME}/data/properties/cadi.properties" >> ${ODL_HOME}/etc/system.properties
echo "" >> ${ODL_HOME}/etc/system.properties

echo "Adding a value to property appc.asdc.env in appc.properties for appc-asdc-listener feature"
echo "" >> $APPC_HOME/data/properties/appc.properties
echo "appc.asdc.env=$DMAAP_TOPIC_ENV" >> $APPC_HOME/data/properties/appc.properties
echo "" >> $APPC_HOME/data/properties/appc.properties

echo "Copying jetty, keystore for https into opendalight"
cp ${APPC_HOME}/data/jetty.xml ${ODL_HOME}/etc/jetty.xml
cp ${APPC_HOME}/data/keystore ${ODL_HOME}/etc/keystore
cp ${APPC_HOME}/data/custom.properties ${ODL_HOME}/etc/custom.properties

echo "Copying a working version of the logging configuration into the opendaylight etc folder"
cp ${APPC_HOME}/data/org.ops4j.pax.logging.cfg ${ODL_HOME}/etc/org.ops4j.pax.logging.cfg

ODL_BOOT_FEATURES_EXTRA="odl-netconf-connector,odl-restconf-noauth,odl-netconf-clustered-topology,odl-mdsal-clustering"
sed -i -e "\|featuresBoot[^a-zA-Z]|s|$|,${ODL_BOOT_FEATURES_EXTRA}|"  $ODL_HOME/etc/org.apache.karaf.features.cfg

exec ${APPC_HOME}/bin/dockerInstall.sh &
echo "Starting OpenDaylight"
exec ${ODL_HOME}/bin/karaf server
