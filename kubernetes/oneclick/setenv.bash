#!/bin/bash

HELM_APPS=('mso' 'message-router' 'sdnc' 'robot')
ONAP_APPS=('sdc' 'aai' 'vid' 'portal' 'policy' 'appc')
ONAP_DOCKER_REGISTRY_KEY=${ONAP_DOCKER_REGISTRY_KEY:-onap-docker-registry-key}
ONAP_DOCKER_REGISTRY=${ONAP_DOCKER_REGISTRY:-nexus3.onap.org:10001}
ONAP_DOCKER_USER=${ONAP_DOCKER_USER:-docker}
ONAP_DOCKER_PASS=${ONAP_DOCKER_PASS:-docker}
ONAP_DOCKER_MAIL=${ONAP_DOCKER_MAIL:-$USERNAME@$USERDOMAIN}
