SDNC_DBHOST_POD=$(/consul/config/bin/kubectl -n namespace-placeholder  get pod | grep -o "sdnc-dbhost-[^[:space:]]*")
if [ -n "$SDNC_DBHOST_POD" ]; then
   if /consul/config/bin/kubectl -n namespace-placeholder exec -it $SDNC_DBHOST_POD -- ./healthcheck.sh |grep -i "mysqld is alive"; then
      echo Success. SDNC DBHost is running. 2>&1
      exit 0
   else
      echo Failed. SDNC DBHost is not running. 2>&1
      exit 1
   fi
else
   echo Failed. SDNC DBHost is offline. 2>&1
   exit 1
fi
