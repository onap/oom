#!/bin/bash

###
# ============LICENSE_START=======================================================
# SDNC
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

function enable_odl_cluster(){
  if [ -z $SDNC_REPLICAS ]; then
     echo "SDNC_REPLICAS is not configured in Env field"
     exit
  fi

  echo "Installing Opendaylight cluster features"
  mv $ODL_HOME/etc/org.apache.karaf.features.cfg $ODL_HOME/etc/org.apache.karaf.features.cfg.orig
  cat $ODL_HOME/etc/org.apache.karaf.features.cfg.orig | sed -e "\|featuresBoot=config|s|$|,odl-mdsal-clustering,odl-jolokia|" > $ODL_HOME/etc/org.apache.karaf.features.cfg
  #${ODL_HOME}/bin/client feature:install odl-mdsal-clustering
  #${ODL_HOME}/bin/client feature:install odl-jolokia

  echo "Update cluster information statically"
  hm=$(hostname)
  echo "Get current Hostname ${hm}"

  node=($(echo ${hm} | sed 's/-[0-9]*$//g'))
  node_index=($(echo ${hm} | awk -F"-" '{print $NF}'))
  member_offset=1

  if $GEO_ENABLED; then
    echo "This is a Geo cluster"

    if [ -z $IS_PRIMARY_CLUSTER ] || [ -z $MY_ODL_CLUSTER ] || [ -z $PEER_ODL_CLUSTER ]; then
     echo "IS_PRIMARY_CLUSTER, MY_ODL_CLUSTER and PEER_ODL_CLUSTER must all be configured in Env field"
     return
    fi

    if $IS_PRIMARY_CLUSTER; then
       PRIMARY_NODE=${MY_ODL_CLUSTER}
       SECONDARY_NODE=${PEER_ODL_CLUSTER}
    else
       PRIMARY_NODE=${PEER_ODL_CLUSTER}
       SECONDARY_NODE=${MY_ODL_CLUSTER}
       member_offset=4
    fi

    node_list="${PRIMARY_NODE} ${SECONDARY_NODE}"

    /opt/onap/sdnc/bin/configure_geo_cluster.sh $((node_index+member_offset)) ${node_list}
  else
    echo "This is a local cluster"

    node_list="${node}-0.{{.Values.service.name}}-cluster.{{.Release.Namespace}}";

    for ((i=1;i<${SDNC_REPLICAS};i++));
    do
      node_list="${node_list} ${node}-$i.{{.Values.service.name}}-cluster.{{.Release.Namespace}}"
    done

    /opt/opendaylight/current/bin/configure_cluster.sh $((node_index+1)) ${node_list}
  fi
}


# Install SDN-C platform components if not already installed and start container

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD:-Kp8bJ4SXszM0WXlhak3eHlcse2gAw84vaoGGmJvUy2U}
SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
SDNC_BIN=${SDNC_BIN:-/opt/onap/sdnc/bin}
CCSDK_HOME=${CCSDK_HOME:-/opt/onap/ccsdk}
SLEEP_TIME=${SLEEP_TIME:-120}
MYSQL_PASSWD=${MYSQL_PASSWD:-{{.Values.config.dbRootPassword}}}
MYSQL_HOST=${MYSQL_HOST:-{{.Values.config.dbServiceName}}.{{.Release.Namespace}}}
ENABLE_ODL_CLUSTER=${ENABLE_ODL_CLUSTER:-false}
GEO_ENABLED=${GEO_ENABLED:-false}
DBINIT_DIR=${DBINIT_DIR:-/opt/opendaylight/current/daexim}

#
# Wait for database to init properly
#
echo "Waiting for mysql"
until mysql -h ${MYSQL_HOST} -u root -p${MYSQL_PASSWD} mysql &> /dev/null
do
  printf "."
  sleep 1
done
echo -e "\nmysql ready"

if [ ! -d ${DBINIT_DIR} ]
then
    mkdir -p ${DBINIT_DIR}
fi

if [ ! -f ${DBINIT_DIR}/.installed ]
then
        echo "Installing SDNC database"
        ${SDNC_HOME}/bin/installSdncDb.sh

        if [ -x ${SDNC_HOME}/svclogic/bin/install.sh ]
        then
                echo "Installing directed graphs"
                ${SDNC_HOME}/svclogic/bin/install.sh
        fi

        echo "Installed at `date`" > ${DBINIT_DIR}/.installed
fi

if [ ! -f ${SDNC_HOME}/.installed ]
then
	echo "Installing SDN-C keyStore"
	${SDNC_HOME}/bin/addSdncKeyStore.sh

	# No longer needed (this was a workaround for bug in Nitrogen)
	#${CCSDK_HOME}/bin/installOdlHostKey.sh

	if $ENABLE_ODL_CLUSTER ; then enable_odl_cluster ; fi

        echo "Installed at `date`" > ${SDNC_HOME}/.installed
fi

cp /opt/opendaylight/current/certs/* /tmp

nohup python ${SDNC_BIN}/installCerts.py &


exec ${ODL_HOME}/bin/karaf server

