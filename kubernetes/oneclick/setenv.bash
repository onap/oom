#!/bin/bash

# Deploying MSB first and kube2msb last will ensure all the ONAP services can be registered to MSB
HELM_APPS=('consul' 'msb' 'mso' 'message-router' 'sdnc' 'vid' 'robot' 'portal' 'policy' 'appc' 'aai' 'sdc' 'openstack' 'dcaegen2' 'log' 'cli' 'multicloud' 'clamp' 'vnfsdk' 'uui' 'aaf' 'vfc' 'kube2msb')
ONAP_DOCKER_REGISTRY=${ONAP_DOCKER_REGISTRY:-nexus3.onap.org:10001}
ONAP_DOCKER_USER=${ONAP_DOCKER_USER:-docker}
ONAP_DOCKER_PASS=${ONAP_DOCKER_PASS:-docker}
ONAP_DOCKER_MAIL=${ONAP_DOCKER_MAIL:-$USERNAME@$USERDOMAIN}

# When deploying DCAEGEN2, OOM will deploy an OpenStack providing DNS Designate
# The two following paramters, allow to configure the password for keystone and mariadb
OPENSTACK_MARIADB_PASSWORD=${OPENSTACK_MARIADB_PASSWORD:-Password123}
OPENSTACK_KEYSTONE_PASSWORD=${OPENSTACK_KEYSTONE_PASSWORD:-Password123}