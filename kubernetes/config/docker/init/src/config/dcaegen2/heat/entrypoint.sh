#/bin/bash

apt update -y
apt -y install python-pip
pip install python-openstackclient
pip install python-heatclient


if [ "OPENSTACK_API_VERSION_HERE" = "v2.0" ]
then
    source /opt/heat/OOM-openrc-v2.sh
else
    source /opt/heat/OOM-openrc-v3.sh
fi

openstack stack create -t /opt/heat/onap_dcae.yaml -e /opt/heat/onap_dcae.env dcae

# wait 10 seconds to let the stack start a little bit, so the ips have been assigned.
sleep 10

DCAE_CONTROLLER_IP=`openstack stack output show dcae dcae_floating_ip -c output_value -f yaml | awk '{ print $2}'`

sed -i -e "s/DCAE_CONTROLLER_IP_HERE/$DCAE_CONTROLLER_IP/g" /opt/robot/vm_properties.py;

# let the pod live even though we're done
sleep infinity
