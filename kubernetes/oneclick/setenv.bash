#!/bin/bash

# Deploying MSB first and kube2msb last will ensure all the ONAP services can be registered to MSB
HELM_APPS=('msb' 'mso' 'message-router' 'sdnc' 'vid' 'robot' 'portal' 'policy' 'appc' 'aai' 'sdc' 'dcae' 'log' 'cli' 'multicloud' 'clamp' 'kube2msb')
ONAP_DOCKER_REGISTRY=${ONAP_DOCKER_REGISTRY:-nexus3.onap.org:10001}
ONAP_DOCKER_USER=${ONAP_DOCKER_USER:-docker}
ONAP_DOCKER_PASS=${ONAP_DOCKER_PASS:-docker}
ONAP_DOCKER_MAIL=${ONAP_DOCKER_MAIL:-$USERNAME@$USERDOMAIN}
