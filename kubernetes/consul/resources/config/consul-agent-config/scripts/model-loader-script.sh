
NAME=$(/consul/config/bin/kubectl -n onap-aai get pod | grep -o "model-loader[^[:space:]]*")

if [ -n "$NAME" ]; then
   if /consul/config/bin/kubectl -n onap-aai exec -it $NAME -- ps -efww | grep 'java' | grep 'model-loader' > /dev/null; then

      echo Success. Model Loader process is running. 2>&1
      exit 0
   else
      echo Failed. Model Loader process is not running. 2>&1
      exit 1
   fi
else
   echo Failed. Model Loader container is offline. 2>&1
   exit 1
fi
