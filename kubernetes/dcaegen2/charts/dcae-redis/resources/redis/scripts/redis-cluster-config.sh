#!/bin/bash
# ================================================================================
# Copyright (c) 2018 AT&T Intellectual Property. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================

(if [[ "$HOSTNAME" == *{{.Chart.Name}}-0 ]]; then
  echo "delay by 10 seconds for redis server starting"
  sleep 10

  NODES=""
  echo "====> wait for all {{.Values.replicaCount}} redis pods up"
  while [ "$(echo $NODES | wc -w)" -lt {{.Values.replicaCount}} ]
  do
    echo "======> $(echo $NODES |wc -w) / {{.Values.replicaCount}} pods up"
    sleep 5
    RESP=$(wget -vO- --ca-certificate /var/run/secrets/kubernetes.io/serviceaccount/ca.crt  --header "Authorization: Bearer $(</var/run/secrets/kubernetes.io/serviceaccount/token)" https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_PORT_443_TCP_PORT/api/v1/namespaces/{{.Release.Namespace}}/pods?labelSelector=app={{.Chart.Name}})

    IPS=$(echo $RESP | jq -r '.items[].status.podIP')
    IPS2=$(echo $IPS | sed -e 's/[a-zA-Z]*//g')
    echo "======> IPs: ["$IPS2"]"
    NODES=""
    for I in $IPS2; do NODES="$NODES $I:{{.Values.service.externalPort}}"; done
    echo "======> nodes: ["$NODES"]"
  done
  echo "====> all {{.Values.replicaCount}} redis cluster pods are up. wait 10 seconds before the next step"; echo
  sleep 10

  echo "====> Configure the cluster"

  # $NODES w/o quotes
  echo "======> nodes: [$(echo $NODES |paste -s)]"
  redis-trib create --replicas 1 $(echo $NODES |paste -s)
fi ) &

redis-server /conf/redis.conf

