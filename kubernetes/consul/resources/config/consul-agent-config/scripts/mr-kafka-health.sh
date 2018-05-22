kafkapod=$(/consul/bin/kubectl -n {{ include "common.namespace" . }} get pod | grep -o "[^[:space:]]*-message-router-kafka-[^[:space:]]*")
if [ -n "$kafkapod" ]; then
   if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $kafkapod -- ps ef | grep -i kafka; then
      echo Success. Kafka process is running. 2>&1
      exit 0
   else
      echo Failed. Kafka is not running. 2>&1
      exit 1
   fi
else
   echo Failed. Kafka container is offline. 2>&1
   exit 1
fi
