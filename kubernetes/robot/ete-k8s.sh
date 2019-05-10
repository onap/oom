# Copyright © 2018 Amdocs, Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#!/bin/bash

#
# Run the testsuite for the passed tag. Valid tags are listed in usage help
# Please clean up logs when you are done...
#
if [ "$1" == "" ] || [ "$2" == "" ]; then
   echo "Usage: ete-k8s.sh [namespace] [tag]"
   echo ""
   echo "  List of test case tags (filename for intent: tag)"
   echo ""
   echo "  cds.robot: cds"
   echo ""
   echo "  clamp.robot: clamp"
   echo ""
   echo "  demo.robot: InitDemo, InitCustomer, APPCCDTPreloadDemo, APPCMountPointDemo, DistributeDemoVFWDT, DistributeVFWNG,"
   echo "              InitDistribution, PreloadDemo, deleteVNF, heatbridge, instantiateDemoVFWCL, instantiateVFW, instantiateVFWCL, instantiateVFWDT"
   echo ""
   echo "  health-check.robot: health, core, small, medium, 3rdparty, api, datarouter, externalapi, health-aaf, health-aai, health-appc,"
   echo "                      health-clamp, health-cli, health-dcae, health-dmaap, health-log, health-modeling, health-msb,"
   echo "                      health-multicloud, health-oof, health-policy, health-pomba, health-portal, health-sdc, health-sdnc,"
   echo "                      health-so, health-uui, health-vfc, health-vid, health-vnfsdk, healthdist, healthlogin, healthmr,"
   echo "                      healthportalapp, multicloud, oom"
   echo ""
   echo " hvves.robot: HVVES, ete"
   echo ""
   echo " model-distribution-vcpe.robot: distributevCPEResCust"
   echo ""
   echo " model-distribution.robot: distribute, distributeVFWDT, distributeVLB"
   echo ""
   echo " oof-*.robot: cmso, has, homing"
   echo ""
   echo " pnf-registration.robot: ete, pnf_registrate"
   echo ""
   echo " post-install-tests.robot dmaapacl, postinstall"
   echo ""
   echo " update_onap_page.robot: UpdateWebPage"
   echo ""
   echo " vnf-orchestration-direct-so.robot: instantiateVFWdirectso"
   echo ""
   echo " vnf-orchestration.robot: instantiate, instantiateNoDelete, stability72hr"
   exit
fi

set -x

export NAMESPACE="$1"

POD=$(kubectl --namespace $NAMESPACE get pods | sed 's/ .*//'| grep robot)

TAGS="-i $2"

ETEHOME=/var/opt/ONAP
export GLOBAL_BUILD_NUMBER=$(kubectl --namespace $NAMESPACE exec  ${POD}  -- bash -c "ls -1q /share/logs/ | wc -l")
OUTPUT_FOLDER=$(printf %04d $GLOBAL_BUILD_NUMBER)_ete_$2
DISPLAY_NUM=$(($GLOBAL_BUILD_NUMBER + 90))

VARIABLEFILES="-V /share/config/vm_properties.py -V /share/config/integration_robot_properties.py -V /share/config/integration_preload_parameters.py"
VARIABLES="-v GLOBAL_BUILD_NUMBER:$$"

kubectl --namespace $NAMESPACE exec ${POD} -- ${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/${OUTPUT_FOLDER} ${TAGS} --display $DISPLAY_NUM
