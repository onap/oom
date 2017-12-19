#!/bin/sh

set -x

export CHEFNAME=${ENVNAME}
# executing chef-solo for configuration
cd /root/chef-solo
echo "normal['HOST_IP'] = \"${HOST_IP}\"" > /root/chef-solo/cookbooks/sdc-catalog-be/attributes/default.rb
chef-solo -c solo.rb -E ${CHEFNAME}

sed -i '/^set -e/aJAVA_OPTIONS=\"-Xdebug -agentlib:jdwp=transport=dt_socket,address=4000,server=y,suspend=n -XX:MaxPermSize=256m -Xmx1500m -Dconfig.home=${JETTY_BASE}\/config -Dlog.home=${JETTY_BASE}\/logs -Dlogback.configurationFile=${JETTY_BASE}\/config\/catalog-be\/logback.xml -Dconfiguration.yaml=${JETTY_BASE}\/config\/catalog-be\/configuration.yaml -Dartifactgenerator.config=${JETTY_BASE}\/config\/catalog-be\/Artifact-Generator.properties\ -Donboarding_configuration.yaml=${JETTY_BASE}\/config\/onboarding-be\/onboarding_configuration.yaml" ' /docker-entrypoint.sh
sed -i '/^set -e/aTMPDIR=${JETTY_BASE}\/temp' /docker-entrypoint.sh

# executiong the jetty
cd /var/lib/jetty
/docker-entrypoint.sh &
MAIN_PID=$!
echo "=> SDC-BE PID is $MAIN_PID"

# add the consumers
cd /root/chef-solo
python /root/chef-solo/cookbooks/sdc-catalog-be/files/default/consumers.py &

# add the user
python /root/chef-solo/cookbooks/sdc-catalog-be/files/default/user.py &

# check if BackEnd is up
python /root/chef-solo/cookbooks/sdc-normatives/files/default/check_Backend_Health.py

# executing the normatives
cd /root/chef-solo
check_normative="/tmp/check_normative.out"
curl -s -X GET -H "Content-Type: application/json;charset=UTF-8" -H "USER_ID: jh0003" -H "X-ECOMP-RequestID: cbe744a0-037b-458f-aab5-df6e543c4090" -H "Cache-Control: no-cache" -H "Postman-Token: af08ca1c-302f-1431-404f-ed84246e07c9" "http://${HOST_IP}:8080/sdc2/rest/v1/screen" > ${check_normative}

echo "normal['HOST_IP'] = \"${HOST_IP}\"" > /root/chef-solo/cookbooks/sdc-normatives/attributes/default.rb
resources_len=`cat ${check_normative}| jq '.["resources"]|length'`
if [ $resources_len -eq 0 ] ; then
   chef-solo -c normatives.rb
else
   sed -i "s/import/upgrade/g" normatives.json
   chef-solo -c normatives.rb
fi

# signal kubernetes that the container is ready
touch /tmp/ready

echo "###### DOCKER STARTED #####"

wait $MAIN_PID
echo "=> SDC-BE process ended. exiting..."
