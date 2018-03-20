
NAME=$(/consul/bin/kubectl -n {{ .Values.nsPrefix }} get pod | grep -o "aai-model-loader[^[:space:]]*")

if [ -n "$NAME" ]; then
   if /consul/bin/kubectl -n {{ .Values.nsPrefix }} exec -it $NAME -- ps -efww | grep 'java' | grep 'model-loader' > /dev/null; then

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
