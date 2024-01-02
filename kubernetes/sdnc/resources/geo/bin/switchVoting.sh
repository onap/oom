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

usage ()
{
    echo usage: switchVoting.sh primary\|secondary
    exit 1
}

if [ $# -ne 1 ]; then
    usage
fi

dir=$( dirname $0 )
USERNAME=admin
PASSWORD=`awk '/odlPassword/ {print $2}' $dir/../../../values.yaml | head -1`

case "$1" in

primary)
   status=$(curl -u $USERNAME:$PASSWORD -o /dev/null -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:30202/rests/operations/cluster-admin:change-member-voting-states-for-all-shards -d '{ "input" : { "member-voting-state" : [ { "member-name" : "member-1", "voting":true}, { "member-name" : "member-2", "voting":true}, { "member-name" : "member-3", "voting":true},{ "member-name" : "member-4", "voting":false},{ "member-name" : "member-5", "voting":false},{ "member-name" : "member-6", "voting":false}] } }' -w "%{http_code}\n" $url 2> /dev/null)
;;

secondary)
   status=$(curl -u $USERNAME:$PASSWORD -o /dev/null -H "Content-Type: application/json" -H "Accept: application/json" -X POST http://localhost:30202/rests/operations/cluster-admin:change-member-voting-states-for-all-shards -d '{ "input" : { "member-voting-state" : [ { "member-name" : "member-1", "voting":false}, { "member-name" : "member-2", "voting":false}, { "member-name" : "member-3", "voting":false},{ "member-name" : "member-4", "voting":true},{ "member-name" : "member-5", "voting":true},{ "member-name" : "member-6", "voting":true}] } }' -w "%{http_code}\n" $url 2> /dev/null)
;;

*)
   usage
esac

if [ $status -ne 200 ];then
  echo "failure"
else
  echo "success"
fi
