NAME=$(/consul/bin/kubectl -n {{ include "common.namespace" . }} get pod | grep -o "[^[:space:]]*-clampdb[^[:space:]]*")

   if [ -n "$NAME" ]; then
       if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $NAME -- bash -c 'mysqladmin status -u root -p$MYSQL_ROOT_PASSWORD' > /dev/null; then
         echo Success. CLAMP DBHost is running. 2>&1
         exit 0
      else
         echo Failed. CLAMP DBHost is not running. 2>&1
         exit 1
      fi
   else
      echo Failed. CLAMP DBHost is offline. 2>&1
      exit 1
   fi

