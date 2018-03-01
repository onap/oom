zkpod=$(/consul/config/bin/kubectl -n namespace-placeholder get pod | grep -o "zookeeper-[^[:space:]]*")
if [ -n "$zkpod" ]; then
   if /consul/config/bin/kubectl -n namespace-placeholder exec -it $zkpod -- ps ef | grep -i zookeeper; then
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
