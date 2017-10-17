
# Query the Hbase service for the cluster status.
GET_CLUSTER_STATUS_RESPONSE=$(curl -si -X GET -H "Accept: text/xml" http://hbase.onap-aai:8080/status/cluster)

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
