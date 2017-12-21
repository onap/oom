NAME=$(/consul/config/bin/kubectl -n onap-policy get pod | grep -o "brmsgw[^[:space:]]*")

if [ -n "$NAME" ]; then
   if /consul/config/bin/kubectl -n onap-policy exec -it $NAME -- ps -efww | grep 'java' | grep 'brmsgw' > /dev/null; then

      echo Success. brmsgw  process is running. 2>&1
      exit 0
   else
      echo Failed. brmsgw process is not running. 2>&1
      exit 1
   fi
else
   echo Failed. brmsgw container is offline. 2>&1
   exit 1
fi
