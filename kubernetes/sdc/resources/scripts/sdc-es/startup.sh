#!/bin/sh

set -x

cd /root/chef-solo/
chef-solo -c solo.rb -E ${ENVNAME}

chef_status=$?

/docker-entrypoint.sh elasticsearch &
MAIN_PID=$!

exec "$@";
wait $MAIN_PID
echo "=> elasticsearch process ended. exiting..."
