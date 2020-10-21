#!/bin/sh
{{/*

# Copyright © 2018 Amdocs
# Modifications Copyright © 2018 AT&T
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

# query ODL cluster state
USERNAME="{{.Values.odl.jolokia.username}}"
PASSWORD="{{.Values.odl.jolokia.password}}"

count=${SDNC_ODL_COUNT:-1}
siteId=0
if [ "$SDNC_IS_PRIMARY_CLUSTER" = "false" ];then
  siteId=1
fi

for instance in $(seq $count);do
  shard=member-$(( $siteId*$count + $instance ))-shard-default-config
  mbean=Category=Shards,name=$shard,type=DistributedConfigDatastore
  url=http://{{ include "common.release" . }}-sdnc-$(( $instance-1 )).sdnc-cluster.{{.Release.Namespace}}:8181/jolokia/read/org.opendaylight.controller:$mbean

  response=$( curl -s -u $USERNAME:$PASSWORD $url )
  rc=$?
  if [ $rc -ne 0 ];then
    # failed to contact SDN-C instance - try another
    echo "Unable to connect to $shard [rc=$?]"
    continue
  fi

  status=$( echo "$response" | jq -r ".status" )
  if [ "$status" != "200" ];then
    # query failed, try another instance
    echo "$shard query failed [http-status=$status]"
    continue
  fi

  raftState=$( echo "$response" | jq -r ".value.RaftState" )
  if [ "$raftState" = "Leader" -o "$raftState" = "Follower" ];then
    # cluster has a leader and is healthy
    echo "$shard is healthy [RaftState=$raftState]"
    exit 0
  else
    echo "$shard is not healthy [RaftState=$raftState]"
  fi
done

# ODL cluster is not healthy
exit 2
