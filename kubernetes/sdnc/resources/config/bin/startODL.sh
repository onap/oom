#!/bin/bash

###
# ============LICENSE_START=======================================================
# SDNC
# ================================================================================
# Copyright © 2020 Samsung Electronics
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

# Append features to karaf boot feature configuration
# $1 additional feature to be added
# $2 repositories to be added (optional)
function addToFeatureBoot() {
  CFG=$ODL_HOME/etc/org.apache.karaf.features.cfg
  ORIG=$CFG.orig
  if [ -n "$2" ] ; then
    echo "Add repository: $2"
    mv $CFG $ORIG
    cat $ORIG | sed -e "\|featuresRepositories|s|$|,$2|" > $CFG
  fi
  echo "Add boot feature: $1"
  mv $CFG $ORIG
  cat $ORIG | sed -e "\|featuresBoot *=|s|$|,$1|" > $CFG
}

# Append features to karaf boot feature configuration
# $1 search pattern
# $2 replacement
function replaceFeatureBoot() {
  CFG=$ODL_HOME/etc/org.apache.karaf.features.cfg
  ORIG=$CFG.orig
  echo "Replace boot feature $1 with: $2"
  sed -i "/featuresBoot/ s/$1/$2/g" $CFG
}

function install_sdnrwt_features() {
  addToFeatureBoot "$SDNRWT_BOOTFEATURES" $SDNRWT_REPOSITORY
}

function enable_odl_cluster(){
  if [ -z $SDNC_REPLICAS ]; then
     echo "SDNC_REPLICAS is not configured in Env field"
     exit
  fi

  #Be sure to remove feature odl-netconf-connector-all from list
  replaceFeatureBoot "odl-netconf-connector-all,"

  echo "Installing Opendaylight cluster features"
  replaceFeatureBoot odl-netconf-topology odl-netconf-clustered-topology
  replaceFeatureBoot odl-mdsal-all odl-mdsal-all,odl-mdsal-clustering
  addToFeatureBoot odl-jolokia
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
ODL_ADMIN_USERNAME=${ODL_ADMIN_USERNAME}
ODL_ADMIN_PASSWORD=${ODL_ADMIN_PASSWORD}
SDNC_HOME=${SDNC_HOME:-/opt/onap/sdnc}
SDNC_BIN=${SDNC_BIN:-/opt/onap/sdnc/bin}
CCSDK_HOME=${CCSDK_HOME:-/opt/onap/ccsdk}
ENABLE_ODL_CLUSTER=${ENABLE_ODL_CLUSTER:-false}
GEO_ENABLED=${GEO_ENABLED:-false}
SDNC_AAF_ENABLED=${SDNC_AAF_ENABLED:-false}
SDNRWT=${SDNRWT:-false}
SDNR_A1_ADAPTER=${SDNR_A1_ADAPTER}
SDNRWT_BOOTFEATURES=${SDNRWT_BOOTFEATURES:-sdnr-wt-feature-aggregator}
export ODL_ADMIN_PASSWORD ODL_ADMIN_USERNAME

echo "Settings:"
echo "  ENABLE_ODL_CLUSTER=$ENABLE_ODL_CLUSTER"
echo "  SDNC_REPLICAS=$SDNC_REPLICAS"
echo "  SDNRWT=$SDNRWT"
echo "  SDNR_A1_ADAPTER=$SDNR_A1_ADAPTER"
echo "  AAF_ENABLED=$SDNC_AAF_ENABLED"


if $SDNC_AAF_ENABLED; then
	export SDNC_AAF_STORE_DIR=/opt/app/osaaf/local
	export SDNC_AAF_CONFIG_DIR=/opt/app/osaaf/local
	export SDNC_KEYPASS=`cat /opt/app/osaaf/local/.pass`
	export SDNC_KEYSTORE=org.onap.sdnc.p12
	sed -i '/cadi_prop_files/d' $ODL_HOME/etc/system.properties
	echo "cadi_prop_files=$SDNC_AAF_CONFIG_DIR/org.onap.sdnc.props" >> $ODL_HOME/etc/system.properties

	sed -i '/org.ops4j.pax.web.ssl.keystore/d' $ODL_HOME/etc/custom.properties
	sed -i '/org.ops4j.pax.web.ssl.password/d' $ODL_HOME/etc/custom.properties
	sed -i '/org.ops4j.pax.web.ssl.keypassword/d' $ODL_HOME/etc/custom.properties
	echo org.ops4j.pax.web.ssl.keystore=$SDNC_AAF_STORE_DIR/$SDNC_KEYSTORE >> $ODL_HOME/etc/custom.properties
	echo org.ops4j.pax.web.ssl.password=$SDNC_KEYPASS >> $ODL_HOME/etc/custom.properties
	echo org.ops4j.pax.web.ssl.keypassword=$SDNC_KEYPASS >> $ODL_HOME/etc/custom.properties
fi

if [ ! -f ${SDNC_HOME}/.installed ]
then
	echo "Installing SDN-C keyStore"
	${SDNC_HOME}/bin/addSdncKeyStore.sh

	if $ENABLE_ODL_CLUSTER ; then enable_odl_cluster ; fi

	if $SDNRWT ; then install_sdnrwt_features ; fi

	if [ "$SDNR_A1_ADAPTER" != "" ]
	then
	  addToFeatureBoot $SDNR_A1_ADAPTER
	fi

  echo "Installed at `date`" > ${SDNC_HOME}/.installed
fi

cp /opt/opendaylight/current/certs/* /tmp

nohup python ${SDNC_BIN}/installCerts.py &


exec ${ODL_HOME}/bin/karaf server
