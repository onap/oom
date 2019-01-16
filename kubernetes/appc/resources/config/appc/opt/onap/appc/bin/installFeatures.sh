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

ODL_HOME=${ODL_HOME:-/opt/opendaylight/current}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}
ENABLE_ODL_CLUSTER=${ENABLE_ODL_CLUSTER:-false}
APPC_FEATURE_DIR=${APPC_FEATURE_DIR:-${APPC_HOME}/features}

function featureInstall {
COUNT=0
while [ $COUNT -lt 10 ]; do
  ${ODL_HOME}/bin/client feature:install $1 2> /tmp/installErr
  cat /tmp/installErr
  if grep -q 'Failed to get the session' /tmp/installErr; then
    sleep 10
  else
    let COUNT=10
  fi
  let COUNT=COUNT+1
done
}

 APPC_FEATURES=" \
 appc-metric \
 appc-dmaap-adapter \
 appc-chef-adapter \
 appc-netconf-adapter \
 appc-rest-adapter \
 appc-lifecycle-management \
 appc-dispatcher \
 appc-provider \
 appc-dg-util \
 appc-dg-shared \
 appc-sdc-listener \
 appc-oam \
 appc-iaas-adapter \
 appc-ansible-adapter \
 appc-sequence-generator \
 appc-artifact-handler \
 appc-aai-client"

APPC_FEATURES_1=" \
 onap-appc-core \
 onap-appc-metric \
 onap-appc-dmaap-adapter \
 onap-appc-chef-adapter \
 onap-appc-netconf-adapter \
 onap-appc-rest-adapter \
 onap-appc-lifecycle-management \
 onap-appc-license-manager"

 APPC_FEATURES_2=" \
 onap-appc-dg-util \
 onap-appc-dg-shared \
 onap-appc-sdc-listener \
 onap-appc-oam \
 onap-appc-iaas-adapter \
 onap-appc-ansible-adapter \
 onap-appc-sequence-generator \
 onap-appc-config-generator \
 onap-appc-config-data-services \
 onap-appc-config-adaptor \
 onap-appc-config-audit \
 onap-appc-config-encryption-tool \
 onap-appc-config-flow-controller \
 onap-appc-config-params \
 onap-appc-artifact-handler
 onap-appc-aai-client \
 onap-appc-event-listener \
 onap-appc-network-inventory-client \
 onap-appc-design-services \
 onap-appc-interfaces-service"

 APPC_FEATURES_UNZIP=" \
 appc-core \
 appc-metric \
 appc-dmaap-adapter \
 appc-event-listener \
 appc-chef-adapter \
 appc-netconf-adapter \
 appc-rest-adapter \
 appc-lifecycle-management \
 appc-dispatcher \
 appc-provider \
 appc-dg-util \
 appc-dg-shared \
 appc-sdc-listener \
 appc-oam \
 appc-iaas-adapter \
 appc-ansible-adapter \
 appc-sequence-generator \
 appc-config-generator \
 appc-config-data-services \
 appc-config-adaptor \
 appc-config-audit \
 appc-config-encryption-tool \
 appc-config-flow-controller \
 appc-config-params \
 appc-artifact-handler \
 appc-aai-client \
 appc-network-inventory-client \
 appc-design-services \
 appc-interfaces-service"


if $ENABLE_ODL_CLUSTER
  then
    echo "Enabling core APP-C features with clustering enabled"
    featureInstall odl-netconf-connector-all
    featureInstall odl-restconf-noauth
    featureInstall odl-netconf-clustered-topology
  else
    echo "Enabling core APP-C features with clustering disabled"
    featureInstall odl-netconf-connector-all
    featureInstall odl-restconf-noauth
    featureInstall odl-netconf-topology
fi

sleep 7s
echo "Installing APP-C Features"
echo ""

for feature in ${APPC_FEATURES_UNZIP}
do
  if [ -f ${APPC_FEATURE_DIR}/${feature}/install-feature.sh ]
  then
    ${APPC_FEATURE_DIR}/${feature}/install-feature.sh
  else
    echo "No installer found for feature ${feature}"
  fi
done

#${ODL_HOME}/bin/client feature:install appc-metric appc-dmaap-adapter appc-event-listener appc-chef-adapter appc-netconf-adapter appc-rest-adapter appc-lifecycle-management appc-dispatcher appc-provider appc-dg-util appc-dg-shared appc-sdc-listener appc-oam appc-iaas-adapter appc-ansible-adapter appc-sequence-generator appc-config-generator appc-config-data-services appc-config-adaptor appc-config-audit appc-config-encryption-tool appc-config-flow-controller appc-config-params appc-artifact-handler appc-aai-client

for feature in ${APPC_FEATURES_1}
do
  echo "Installing ${feature}"
  start=$(date +%s)
  ${ODL_HOME}/bin/client "feature:install -r ${feature}"
  end=$(date +%s)
  echo "Install of ${feature} took $(expr $end - $start) seconds"
  sleep 7s
  echo "Sleep Finished"
done

  echo "Installing dispatcher features"
  start=$(date +%s)
  ${ODL_HOME}/bin/client "feature:install -r onap-appc-request-handler onap-appc-command-executor onap-appc-lifecycle-management onap-appc-workflow-management lock-manager onap-appc-provider"
  end=$(date +%s)
  echo "Install of dispatcher features took $(expr $end - $start) seconds"
  sleep 7s
  echo "Sleep Finished"

for feature in ${APPC_FEATURES_2}
do
  echo "Installing ${feature}"
  start=$(date +%s)
  ${ODL_HOME}/bin/client "feature:install -r ${feature}"
  end=$(date +%s)
  echo "Install of ${feature} took $(expr $end - $start) seconds"
  sleep 7s
  echo "Sleep Finished"
done

