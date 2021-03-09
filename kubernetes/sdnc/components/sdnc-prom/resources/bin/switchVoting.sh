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

set -e
primary=${SDNC_IS_PRIMARY_CLUSTER:-true}

url=http://sdnc:8282/restconf/operations/cluster-admin:change-member-voting-states-for-all-shards
username="${ODL_USERNAME:-{{.Values.odl.restconf.username}}}"
password="${ODL_PASSWORD:-{{.Values.odl.restconf.password}}}"
LOGFILE="/app/geo.log"
enableDebugLogging=true

debugLog(){
  if [ "$enableDebugLogging" = true ]; then
     if [ $# -eq 0 ]; then
       echo "" >> $LOGFILE
     else
       echo $( date ) $@ >> $LOGFILE
    fi
  fi
}


if [ "$primary" = "true" ]; then
   votingState='
{
  "input": {
    "member-voting-state": [
      {
        "member-name": "member-1",
        "voting": true
      },
      {
        "member-name": "member-2",
        "voting": true
      },
      {
        "member-name": "member-3",
        "voting": true
      },
      {
        "member-name": "member-4",
        "voting": false
      },
      {
        "member-name": "member-5",
        "voting": false
      },
      {
        "member-name": "member-6",
        "voting": false
      }
    ]
  }
}'
else
   votingState='
{
  "input": {
    "member-voting-state": [
      {
        "member-name": "member-1",
        "voting": false
      },
      {
        "member-name": "member-2",
        "voting": false
      },
      {
        "member-name": "member-3",
        "voting": false
      },
      {
        "member-name": "member-4",
        "voting": true
      },
      {
        "member-name": "member-5",
        "voting": true
      },
      {
        "member-name": "member-6",
        "voting": true
      }
    ]
  }
}'
fi

status=$(curl -s -u $username:$password -o /dev/null -H "Content-Type: application/json" -H "Accept: application/json" -X POST -d "$votingState" -w "%{http_code}\n" $url 2> /dev/null)
if [ $status -ne 200 ];then
  debugLog "Switch voting failed. status: $status ,username: $username ,password: $password ,votingState: $votingState ,url:$url   "
  echo "failure"
else
  echo "success"
fi

