NAME=$(/consul/config/bin/kubectl -n namespace-placeholder get pod | grep -o "mariadb[^[:space:]]*")

   if [ -n "$NAME" ]; then
       if /consul/config/bin/kubectl -n namespace-placeholder exec -it $NAME -- bash -c 'mysqladmin status -u root -p$MYSQL_ROOT_PASSWORD' > /dev/null; then
         echo Success. mariadb process is running. 2>&1
         exit 0
      else
         echo Failed. mariadb process is not running. 2>&1
         exit 1
      fi
   else
      echo Failed. mariadb container is offline. 2>&1
      exit 1
   fi
