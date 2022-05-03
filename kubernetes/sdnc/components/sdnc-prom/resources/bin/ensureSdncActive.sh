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

failover(){
  lockFile=/tmp/sdnc.failover.lock
  # make sure that no failover is currently running
  if [ -e ${lockFile} ] && kill -0 $(cat ${lockFile}) 2> /dev/null; then
    debugLog "Currently running sdnc and dns failover"
    return
  fi
  trap "rm -f ${lockFile}" INT TERM EXIT
  echo $$ > ${lockFile}

  # perform takeover
  debugLog "Started executing sdnc.failover for $SITE_NAME"
  takeoverResult=$( /app/bin/sdnc.failover )
  debugLog "Completed executing sdnc.failover. takeoverResult is: $takeoverResult"
  if [ "success" = "$takeoverResult" ]; then
    # update CoreDNS upon successful execution of sdnc.failover script
    debugLog "Executing sdnc.dnsswitch"
    /app/bin/sdnc.dnsswitch
    rc=$?
    debugLog "Completed executing sdnc.dnsswitch for $SITE_NAME. rc=$rc"
  else
    debugLog "Cluster takeover current status: $takeoverResult on $SITE_NAME."
    rc=1
  fi

  if [ $rc -ne 0 ];then
    takeoverResult="failure"
  fi

  data="{\
\"type\": \"failover\",\
\"status\": \"$takeoverResult\",\
\"site\": \"$SITE_NAME\",\
\"deployment\": \"{{.Values.config.deployment}}\",\
\"timestamp\": \"$(date '+%F %T')\"\
}"

  # notifications are best-effort - ignore any failures
  curl -H "Content-Type: application/json" -X POST --data "$data" http://$message_router/events/$topic >/dev/null 2>&1

}

LOGFILE="/app/geo.log"
enableDebugLogging=true
message_router=message-router:3904
topic={{.Values.config.messageRouterTopic}}
SITE_NAME="sdnc01"
if [ "$SDNC_IS_PRIMARY_CLUSTER" = "false" ];then
  SITE_NAME="sdnc02"
fi

debugLog
debugLog "Executing ensureSdncActive"

# query SDN-C cluster status
debugLog "Started executing sdnc.cluster"
clusterStatus=$( /app/bin/sdnc.cluster )
debugLog "Completed executing sdnc.cluster. Cluster status is: $clusterStatus"

if [ "active" = "$clusterStatus" ]; then
  # peform health-check
  debugLog "Started excuting sdnc.monitor"
  health=$( /app/bin/sdnc.monitor )
  debugLog "Completed executing sdnc.monitor. Cluster is: $health"

  if [ "healthy" = "$health" ]; then
    # Cluster is ACTIVE and HEALTHY
    exit 0
  fi
  exit 1

elif [ "standby" = "$clusterStatus" ]; then
  # Run failover in background process and allow PROM to continue
  ( failover & )
  exit 0
fi

# Unknown cluster status
exit 1
