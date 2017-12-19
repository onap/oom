#!/bin/sh

set -x

export CHEFNAME=${ENVNAME}
cd /root/chef-solo
echo "normal['HOST_IP'] = \"${HOST_IP}\"" > /root/chef-solo/cookbooks/sdc-elasticsearch/attributes/default.rb

sed -i '/^exec/iES_JAVA_OPTS=\"-Xms1024M -Xmx1024M\"' /docker-entrypoint.sh

chef-solo -c solo.rb -E ${CHEFNAME}

/docker-entrypoint.sh elasticsearch &
MAIN_PID=$!

sleep 10

if ! ps -p $MAIN_PID > /dev/null; then
  echo "=> ElasticSearch is not running. exiting..."
  exit 1
fi

cd /root/chef-solo
chef-solo -c solo.rb -o recipe[sdc-elasticsearch::ES_3_create_audit_template]
chef-solo -c solo.rb -o recipe[sdc-elasticsearch::ES_4_create_resources_template]
chef-solo -c solo.rb -o recipe[sdc-elasticsearch::ES_5_create_monitoring_template]
chef-solo -c solo.rb -o recipe[sdc-elasticsearch::ES_6_create_kibana_dashboard_virtualization]

# signal kubernetes that the container is ready
touch /tmp/ready

wait $MAIN_PID
echo "=> ElasticSearch process ended. exiting..."
