NAME=$(/consul/config/bin/kubectl -n onap-vid get pod | grep -o "vid-mariadb[^[:space:]]*")

   if [ -n "$NAME" ]; then
       if /consul/config/bin/kubectl -n onap-vid exec -it $NAME -- bash -c 'mysqladmin status -u root -p$MYSQL_ROOT_PASSWORD' > /dev/null; then
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
