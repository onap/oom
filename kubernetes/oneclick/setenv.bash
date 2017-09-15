#!/bin/bash

HELM_APPS=('msb' 'mso' 'message-router' 'sdnc' 'vid' 'robot' 'portal' 'policy' 'appc' 'aai' 'sdc' 'dcae' 'log' 'cli' 'kube2msb')
ONAP_DOCKER_REGISTRY=${ONAP_DOCKER_REGISTRY:-nexus3.onap.org:10001}
ONAP_DOCKER_USER=${ONAP_DOCKER_USER:-docker}
ONAP_DOCKER_PASS=${ONAP_DOCKER_PASS:-docker}
ONAP_DOCKER_MAIL=${ONAP_DOCKER_MAIL:-$USERNAME@$USERDOMAIN}
