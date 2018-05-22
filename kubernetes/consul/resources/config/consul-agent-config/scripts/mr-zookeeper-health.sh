zkpod=$(/consul/bin/kubectl -n {{ include "common.namespace" . }} get pod | grep -o "[^[:space:]]*-message-router-zookeeper-[^[:space:]]*")
if [ -n "$zkpod" ]; then
   if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $zkpod -- ps aux | grep -i zookeeper; then
      echo Success. Zookeeper process is running. 2>&1
      exit 0
   else
      echo Failed. Zookeeper is not running. 2>&1
      exit 1
   fi
else
   echo Failed. Zookeeper container is offline. 2>&1
   exit 1
fi
