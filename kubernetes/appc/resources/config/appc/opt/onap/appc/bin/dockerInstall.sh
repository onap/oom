#!/bin/bash

###
# ============LICENSE_START=======================================================
# APPC
# ================================================================================
# Copyright (C) 2019 AT&T Intellectual Property. All rights reserved.
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

#
# This script runs during docker image build.
# It starts opendaylight, installs the appc features, then shuts down opendaylight.
#
ODL_HOME=${ODL_HOME:-/opt/opendaylight}
SDNC_HOME=${SDNC_HOME:-/opt/onap/ccsdk}
APPC_HOME=${APPC_HOME:-/opt/onap/appc}

appcInstallStartTime=$(date +%s)

TIME_OUT=1000
INTERVAL=30
TIME=0
echo "Checking that Karaf can be accessed"
while [ "$TIME" -lt "$TIME_OUT" ]; do

##clientOutput=$(${ODL_HOME}/bin/client shell:echo KarafLoginCheckIsWorking)
  clientOutput=$(sshpass -pkaraf ssh -o StrictHostKeyChecking=no karaf@localhost -p 8101 "shell:echo KarafLoginCheckIsWorking")
  if echo "$clientOutput" | grep -q "KarafLoginCheckIsWorking"; then
    echo "Karaf login succeeded"
    echo localhost ready in $TIME seconds
    break;
  else
     echo Sleep: $INTERVAL seconds before localhost address is ready. Total wait time up now is: $TIME seconds. Timeout is: $TIME_OUT seconds
  fi

  sleep $INTERVAL
  TIME=$(($TIME+$INTERVAL))
done

if [ "$TIME" -ge "$TIME_OUT" ]; then
  echo "Error during Karaf login, abort manual run dockerInstall.sh to instaill APPC platform features"
  exit 1
fi

echo "Karaf login is ready, installing APPC platform features"
${APPC_HOME}/bin/installFeatures.sh

appcInstallEndTime=$(date +%s)
echo "Total Appc install took $(expr $appcInstallEndTime - $appcInstallStartTime) seconds"
