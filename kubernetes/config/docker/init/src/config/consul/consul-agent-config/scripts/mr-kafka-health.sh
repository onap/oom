kafkapod=$(/consul/config/bin/kubectl -n namespace-placeholder get pod | grep -o "global-kafka-[^[:space:]]*")
if [ -n "$kafkapod" ]; then
   if /consul/config/bin/kubectl -n namespace-placeholder exec -it $kafkapod -- ps ef | grep -i kafka; then
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
