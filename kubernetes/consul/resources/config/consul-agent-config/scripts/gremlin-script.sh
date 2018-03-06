
NAME=$(/consul/bin/kubectl -n {{ .Values.nsPrefix }} get pod | grep -o "gremlin[^[:space:]]*")

if [ -n "$NAME" ]; then
   if /consul/bin/kubectl -n {{ .Values.nsPrefix }} exec -it $NAME -- ps -efww | grep 'java' | grep 'gremlin-server' > /dev/null; then

      echo Success. Gremlin Server process is running. 2>&1
      exit 0
   else
      echo Failed. Gremlin Server process is not running. 2>&1
      exit 1
   fi
else
   echo Failed. Gremlin Server container is offline. 2>&1
   exit 1
fi
