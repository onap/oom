#!/bin/sh

{{/*
# Copyright © 2018 Amdocs
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
*/}}

debugLog(){
  if [ "$enableDebugLogging" = true ]; then
     if [ $# -eq 0 ]; then
       echo "" >> $LOGFILE
     else
       echo $( date ) $@ >> $LOGFILE
    fi
  fi
}

LOGFILE="/app/geo.log"
enableDebugLogging=true

debugLog
debugLog "Executing ensureSdncStandby"

# query SDN-C cluster status
debugLog "Started executing sdnc.cluster"
clusterStatus=$( /app/bin/sdnc.cluster )
debugLog "Completed executing sdnc.cluster. Cluster status is: $clusterStatus"

if [ "active" = "$clusterStatus" ]; then
  # assume transient error as other side transitions to ACTIVE
  debugLog "Cluster status: $clusterStatus. exit 0"
  exit 0

elif [ "standby" = "$clusterStatus" ]; then
  # check that standby cluster is healthy
  debugLog "Started executing sdnc.monitor. Cluster status is: $clusterStatus"
  health=$( /app/bin/sdnc.monitor )
  debugLog "Completed executing sdnc.monitor. Cluster is: $health"
  if [ "failure" = "$health" ];then
    # Backup site is unhealthy - can't accept traffic!
    exit 1
  fi
  # Cluster is standing by
  exit 0
fi

debugLog "Unknown cluster status: $clusterStatus"
# Unknown cluster status
exit 1
