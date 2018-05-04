
NAME=$(/consul/bin/kubectl -n {{ include "common.namespace" . }} get pod | grep -o "aai-data-router[^[:space:]]*")

if [ -n "$NAME" ]; then
   if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $NAME -- ps -efww | grep 'java' | grep 'data-router' > /dev/null; then

      echo Success. Synapse process is running. 2>&1
      exit 0
   else
      echo Failed. Synapse process is not running. 2>&1
      exit 1
   fi
else
   echo Failed. Synapse container is offline. 2>&1
   exit 1
fi
