#/bin/bash

apt update -y
apt -y install python-pip
pip install python-openstackclient
pip install python-heatclient

source /opt/heat/OOM-openrc.sh

openstack stack create -t /opt/heat/onap_dcae.yaml -e /opt/heat/onap_dcae.env dcae

# let the pod live even though we're done
sleep infinity
