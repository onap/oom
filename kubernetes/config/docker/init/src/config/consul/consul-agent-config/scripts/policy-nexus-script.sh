NAME=$(/consul/config/bin/kubectl -n onap-policy get pod | grep -o "nexus[^[:space:]]*")
  if [ -n "$NAME" ]; then
      if /consul/config/bin/kubectl -n onap-policy exec -it $NAME -- /opt/nexus/nexus-2.14.2-01/bin/nexus status > /dev/null; then
         echo Success. nexus OSS process is running. 2>&1
         exit 0
      else
         echo Failed. nexus OSS process is not running. 2>&1
         exit 1
      fi
   else
      echo Failed. nexus OSS container is offline. 2>&1
      exit 1
   fi
