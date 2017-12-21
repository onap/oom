NAME=$(/consul/config/bin/kubectl -n onap-policy get pod | grep -o "mariadb[^[:space:]]*")
  if [ -n "$NAME" ]; then
PASSWORD=$(/consul/config/bin/kubectl -n onap-policy exec -it $NAME -- cat /tmp/do-start.sh |grep 'mysql -uroot -p' | cut -d 'p' -f 2 |cut -d '\' -f 1)   
     if  [ -n "$PASSWORD" ] && /consul/config/bin/kubectl -n onap-policy exec -it $NAME -- mysqladmin status  --user=root --password=$PASSWORD> /dev/null; then 
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
