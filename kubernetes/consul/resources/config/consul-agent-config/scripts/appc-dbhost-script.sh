APPC_DBHOST_POD=$(/consul/bin/kubectl -n {{ include "common.namespace" . }}  get pod | grep -o "appc-dbhost-[^[:space:]]*")
if [ -n "$APPC_DBHOST_POD" ]; then
   if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $APPC_DBHOST_POD -- ./healthcheck.sh |grep -i "mysqld is alive"; then
      echo Success. APPC DBHost is running. 2>&1
      exit 0
   else
      echo Failed. APPC DBHost is not running. 2>&1
      exit 1
   fi
else
   echo Failed. APPC DBHost is offline. 2>&1
   exit 1
fi
