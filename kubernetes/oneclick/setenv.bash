#!/bin/bash

# Deploying MSB first and kube2msb last will ensure all the ONAP services can be registered to MSB
HELM_APPS=('consul' 'msb' 'mso' 'message-router' 'sdnc' 'vid' 'robot' 'portal' 'policy' 'appc' 'aai' 'sdc' 'dcaegen2' 'log' 'cli' 'multicloud' 'clamp', 'vnfsdk', 'kube2msb')
ONAP_DOCKER_REGISTRY=${ONAP_DOCKER_REGISTRY:-nexus3.onap.org:10001}
ONAP_DOCKER_USER=${ONAP_DOCKER_USER:-docker}
ONAP_DOCKER_PASS=${ONAP_DOCKER_PASS:-docker}
ONAP_DOCKER_MAIL=${ONAP_DOCKER_MAIL:-$USERNAME@$USERDOMAIN}
# Openstack key pair private key file location required to enable dcaegen2 installer CRUD operations in your Openstack
# Ensure you set the name of your keypair in the dcae-parameters.yaml entry "keypair: "dcae-g2"
# example: export OPENSTACK_PRIVATE_KEY_PATH=/home/user/Downloads/dcae-g2.pem
OPENSTACK_PRIVATE_KEY_PATH=${OPENSTACK_PRIVATE_KEY_PATH:-~/.ssh/onap_rsa}
# dcaegen2 bootstrap configuration input yaml file.  Start from the sample, and set your environments real values:
# example: export DCAEGEN2_CONFIG_INPUT_FILE_PATH=/tmp/dcae-parameters.yaml
DCAEGEN2_CONFIG_INPUT_FILE_PATH=${DCAEGEN2_CONFIG_INPUT_FILE_PATH:-../dcaegen2/dcae-parameters-sample.yaml}
