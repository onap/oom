#!/bin/bash

set -x

cp /root/recipes/04-schemaCreation.rb /root/chef-solo/cookbooks/cassandra-actions/recipes/04-schemaCreation.rb
cp /root/recipes/05-titanSchemaCreation.rb /root/chef-solo/cookbooks/cassandra-actions/recipes/05-titanSchemaCreation.rb

cd /root/chef-solo
echo "normal['HOST_IP'] = \"${HOST_IP}\"" >> /root/chef-solo/cookbooks/cassandra-actions/attributes/default.rb
echo "normal['Nodes']['CS'] = \"${HOST_IP}\"" >> /root/chef-solo/cookbooks/cassandra-actions/attributes/default.rb

export CHEFNAME=${ENVNAME}

sed -i "s/HOSTIP/${HOST_IP}/g" /root/chef-solo/cookbooks/cassandra-actions/recipes/02-createCsUser.rb
sed -i "s/HOSTIP/${HOST_IP}/g" /root/chef-solo/cookbooks/cassandra-actions/recipes/03-createDoxKeyspace.rb
sed -i "s/HOSTIP/${HOST_IP}/g" /root/chef-solo/cookbooks/cassandra-actions/recipes/04-schemaCreation.rb

chef-solo -c solo.rb -o recipe[cassandra-actions::01-configureCassandra] -E ${CHEFNAME}
rc=$?

if [[ $rc != 0 ]]; then exit $rc; fi
echo "########### starting cassandra ###########"
# start cassandra
/docker-entrypoint.sh cassandra -f &
MAIN_PID=$!

sleep 10

if ! ps -p $MAIN_PID > /dev/null; then
  echo "=> cassandra is not running. exiting..."
  exit 1
fi

chef-solo -c solo.rb  -E ${CHEFNAME}
rc=$?
echo "=> chef-solo returned with status $rc"
if [[ $rc != 0 ]]; then exit $rc; fi

# signal kubernetes that the container is ready
touch /tmp/ready

wait $MAIN_PID
echo "=> cassandra process ended. exiting..."
