# Copyright © 2017 Amdocs, Bell Canada
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


# Query the Hbase service for the cluster status.
GET_CLUSTER_STATUS_RESPONSE=$(curl -si -X GET -H "Accept: text/xml" http://hbase.{{ .Values.nsPrefix }}:8080/status/cluster)

if [ -z "$GET_CLUSTER_STATUS_RESPONSE" ]; then
  echo "Tabular store is unreachable."
  return 2 
fi

# Check the resulting status JSON to see if there is a 'DeadNodes' stanza with 
# entries.
DEAD_NODES=$(echo $GET_CLUSTER_STATUS_RESPONSE | grep "<DeadNodes/>")

if [ -n "$DEAD_NODES" ]; then
  echo "Tabular store is up and accessible."
  return 0
else
  echo "Tabular store is up but is reporting dead nodes - cluster may be in degraded state."
  return 1
fi
