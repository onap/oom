# Copyright © 2018 Amdocs, AT&T, Bell Canada
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

function usage()
{
    echo usage: switchVoting.sh primary\|secondary
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

partition=$1

if [ "$partition" == "primary" ]; then
   curl -u admin:{{.Values.config.odlPassword}} -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:30202/restconf/operations/cluster-admin:change-member-voting-states-for-all-shards -d '{ "input" : { "member-voting-state" : [ { "member-name" : "member-1", "voting":true}, { "member-name" : "member-2", "voting":true}, { "member-name" : "member-3", "voting":true},{ "member-name" : "member-4", "voting":false},{ "member-name" : "member-5", "voting":false},{ "member-name" : "member-6", "voting":false}] } }' > switch_voting_resp.json 2>/dev/null
   echo "" >> switch_voting_resp.json
   exit 0
fi

if [ "$partition" == "secondary" ]; then
   curl -u admin:{{.Values.config.odlPassword}} -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:30202/restconf/operations/cluster-admin:change-member-voting-states-for-all-shards -d '{ "input" : { "member-voting-state" : [ { "member-name" : "member-1", "voting":false}, { "member-name" : "member-2", "voting":false}, { "member-name" : "member-3", "voting":false},{ "member-name" : "member-4", "voting":true},{ "member-name" : "member-5", "voting":true},{ "member-name" : "member-6", "voting":true}] } }' > switch_voting_resp.json 2>/dev/null
   echo "" >> switch_voting_resp.json
   exit 0
fi

usage
