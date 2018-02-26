
NAME=$(/consul/config/bin/kubectl -n onap-aai get pod | grep -o "data-router[^[:space:]]*")

if [ -n "$NAME" ]; then
   if /consul/config/bin/kubectl -n onap-aai exec -it $NAME -- ps -efww | grep 'java' | grep 'data-router' > /dev/null; then

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
