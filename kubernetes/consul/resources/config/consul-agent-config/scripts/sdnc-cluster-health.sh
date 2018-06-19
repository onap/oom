#!/bin/sh

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
  url=http://{{.Release.Name}}-sdnc-$(( $instance-1 )).sdnc-cluster.{{.Release.Namespace}}:8181/jolokia/read/org.opendaylight.controller:$mbean

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
