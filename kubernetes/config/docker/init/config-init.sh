#!/bin/bash -x

echo "Validating onap-parameters.yaml has been populated"

[[ -z "$NEXUS_HTTP_REPO" ]] && { echo "Error: NEXUS_HTTP_REPO must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$NEXUS_DOCKER_REPO" ]] && { echo "Error: NEXUS_DOCKER_REPO must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$NEXUS_USERNAME" ]] && { echo "Error: NEXUS_USERNAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$NEXUS_PASSWORD" ]] && { echo "Error: NEXUS_PASSWORD must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$OPENSTACK_PUBLIC_NET_ID" ]] && { echo "Error: OPENSTACK_PUBLIC_NET_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_PUBLIC_NET_NAME" ]] && { echo "Error: OPENSTACK_PUBLIC_NET_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_OAM_NETWORK_CIDR" ]] && { echo "Error: OPENSTACK_OAM_NETWORK_CIDR must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DCAE_IP_ADDR" ]] && { echo "Error: DCAE_IP_ADDR must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DNS_IP_ADDR" ]] && { echo "Error: DNS_IP_ADDR must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$K8S_IP_ADDR" ]] && { echo "Error: K8S_IP_ADDR must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$OPENSTACK_USERNAME" ]] && { echo "Error: OPENSTACK_USERNAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_API_KEY" ]] && { echo "Error: OPENSTACK_API_KEY must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_NAME" ]] && { echo "Error: OPENSTACK_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_ID" ]] && { echo "Error: OPENSTACK_TENANT_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_REGION" ]] && { echo "Error: OPENSTACK_REGION must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_KEYSTONE_URL" ]] && { echo "Error: OPENSTACK_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_SERVICE_TENANT_NAME" ]] && { echo "Error: OPENSTACK_SERVICE_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$OPENSTACK_FLAVOUR_SMALL" ]] && { echo "Error: OPENSTACK_FLAVOUR_SMALL must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_FLAVOUR_MEDIUM" ]] && { echo "Error: OPENSTACK_FLAVOUR_MEDIUM must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_FLAVOUR_XLARGE" ]] && { echo "Error: OPENSTACK_FLAVOUR_XLARGE must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$OPENSTACK_UBUNTU_14_IMAGE" ]] && { echo "Error: OPENSTACK_UBUNTU_14_IMAGE must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_UBUNTU_16_IMAGE" ]] && { echo "Error: OPENSTACK_UBUNTU_16_IMAGE must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_CENTOS_7_IMAGE" ]] && { echo "Error: OPENSTACK_CENTOS_7_IMAGE must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$DMAAP_TOPIC" ]] && { echo "Error: DMAAP_TOPIC must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DEMO_ARTIFACTS_VERSION" ]] && { echo "Error: DEMO_ARTIFACTS_VERSION must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$DCAE_VM_BASE_NAME" ]] && { echo "Error: DCAE_VM_BASE_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DCAE_DOCKER_VERSION" ]] && { echo "Error: DCAE_DOCKER_VERSION must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$OPENSTACK_KEY_NAME" ]] && { echo "Error: OPENSTACK_KEY_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_PUB_KEY" ]] && { echo "Error: OPENSTACK_PUB_KEY must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_PRIVATE_KEY" ]] && { echo "Error: OPENSTACK_PRIVATE_KEY must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$DNS_LIST" ]] && { echo "Error: DNS_LIST must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$EXTERNAL_DNS" ]] && { echo "Error: EXTERNAL_DNS must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_NAME" ]] && { echo "Error: OPENSTACK_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$DNSAAS_PROXY_ENABLE" ]] && { echo "Error: DNSAAS_PROXY_ENABLE must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DNSAAS_REGION" ]] && { echo "Error: DNSAAS_REGION must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DNSAAS_KEYSTONE_URL" ]] && { echo "Error: DNSAAS_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DNSAAS_TENANT_NAME" ]] && { echo "Error: DNSAAS_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DNSAAS_USERNAME" ]] && { echo "Error: DNSAAS_USERNAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DNSAAS_PASSWORD" ]] && { echo "Error: DNSAAS_PASSWORD must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DCAE_DOMAIN" ]] && { echo "Error: DCAE_DOMAIN must be set in onap-parameters.yaml"; exit 1; }

#make NAMESPACE directory
echo "Creating $NAMESPACE directory if it doesn't exist"
mkdir -p /config-init/$NAMESPACE/

#unzip the configs in the NAMESPACEs directory ensuring no overwriting of files
echo "Installing configuration files"
cp -vnpr /opt/config/src/* /config-init/$NAMESPACE/

#ensure db directories exist.
mkdir -p /config-init/$NAMESPACE/appc/data/
mkdir -p /config-init/$NAMESPACE/dcae/pgaas/pgdata/
mkdir -p /config-init/$NAMESPACE/portal/mariadb/data/
mkdir -p /config-init/$NAMESPACE/portal/logs/
mkdir -p /config-init/$NAMESPACE/sdnc/data/
mkdir -p /config-init/$NAMESPACE/vid/mariadb/data/
mkdir -p /config-init/$NAMESPACE/sdc/sdc-cs/CS/
mkdir -p /config-init/$NAMESPACE/sdc/sdc-es/ES/
mkdir -p /config-init/$NAMESPACE/sdc/logs/ASDC/ASDC-ES/
mkdir -p /config-init/$NAMESPACE/sdc/logs/ASDC/ASDC-CS/
mkdir -p /config-init/$NAMESPACE/sdc/logs/ASDC/ASDC-KB/
mkdir -p /config-init/$NAMESPACE/sdc/logs/ASDC/ASDC-BE/
mkdir -p /config-init/$NAMESPACE/sdc/logs/ASDC/ASDC-FE/
mkdir -p /config-init/$NAMESPACE/aai/opt/aai/logroot/
mkdir -p /config-init/$NAMESPACE/aai/model-loader/logs/
mkdir -p /config-init/$NAMESPACE/aai/aai-traversal/logs/
mkdir -p /config-init/$NAMESPACE/aai/aai-resources/logs/
mkdir -p /config-init/$NAMESPACE/aai/sparky-be/logs/
mkdir -p /config-init/$NAMESPACE/aai/elasticsearch/es-data/
mkdir -p /config-init/$NAMESPACE/aai/search-data-service/logs/
mkdir -p /config-init/$NAMESPACE/aai/data-router/logs/
mkdir -p /config-init/$NAMESPACE/mso/mariadb/data
mkdir -p /config-init/$NAMESPACE/clamp/mariadb/data
mkdir -p /config-init/$NAMESPACE/log/elasticsearch/data
mkdir -p /config-init/$NAMESPACE/consul/consul-agent-config/bin
mkdir -p /config-init/$NAMESPACE/consul/consul-agent-config/scripts
mkdir -p /config-init/$NAMESPACE/consul/consul-server-config

echo "Setting permissions to container writeable directories"
chmod -R 777 /config-init/$NAMESPACE/sdc/logs/
chmod -R 777 /config-init/$NAMESPACE/portal/logs/
chmod -R 777 /config-init/$NAMESPACE/aai/aai-config/
chmod -R 777 /config-init/$NAMESPACE/aai/aai-data/
chmod -R 777 /config-init/$NAMESPACE/aai/opt/aai/logroot/
chmod -R 777 /config-init/$NAMESPACE/aai/model-loader/logs/
chmod -R 777 /config-init/$NAMESPACE/aai/haproxy/log/
chmod -R 777 /config-init/$NAMESPACE/aai/aai-traversal/logs/
chmod -R 777 /config-init/$NAMESPACE/aai/aai-resources/logs/
chmod -R 777 /config-init/$NAMESPACE/aai/sparky-be/logs/
chmod -R 777 /config-init/$NAMESPACE/aai/elasticsearch/es-data/
chmod -R 777 /config-init/$NAMESPACE/aai/search-data-service/logs/
chmod -R 777 /config-init/$NAMESPACE/aai/data-router/logs/
chmod -R 777 /config-init/$NAMESPACE/policy/mariadb/
chmod -R 777 /config-init/$NAMESPACE/log/elasticsearch
chown -R root:root /config-init/$NAMESPACE/log

echo "Substituting configuration parameters"

# replace the default 'onap' namespace qualification of K8s hostnames within the config files
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/\.onap-/\.$NAMESPACE-/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/kubectl -n onap/kubectl -n $NAMESPACE/g" {} \;

#########
# NEXUS #
#########
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,NEXUS_HTTP_REPO_HERE,$NEXUS_HTTP_REPO,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,NEXUS_DOCKER_REPO_HERE,$NEXUS_DOCKER_REPO,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/NEXUS_USERNAME_HERE/$NEXUS_USERNAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/NEXUS_PASSWORD_HERE/$NEXUS_PASSWORD/g" {} \;

##########
# Images #
##########
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/UBUNTU_14_IMAGE_NAME_HERE/$OPENSTACK_UBUNTU_14_IMAGE/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/UBUNTU_16_IMAGE_NAME_HERE/$OPENSTACK_UBUNTU_16_IMAGE/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_CENTOS_7_IMAGE_HERE/$OPENSTACK_CENTOS_7_IMAGE/g" {} \;

##############
# Networking #
##############
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_PUBLIC_NET_ID_HERE/$OPENSTACK_PUBLIC_NET_ID/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_PUBLIC_NET_NAME_HERE/$OPENSTACK_PUBLIC_NET_NAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_NETWORK_ID_WITH_ONAP_ROUTE_HERE/$OPENSTACK_OAM_NETWORK_ID/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_SUBNET_ID_WITH_ONAP_ROUTE_HERE/$OPENSTACK_OAM_SUBNET_ID/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,NETWORK_CIDR_WITH_ONAP_ROUTE_HERE,$OPENSTACK_OAM_NETWORK_CIDR,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DCAE_IP_ADDR_HERE/$DCAE_IP_ADDR/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNS_IP_ADDR_HERE/$DNS_IP_ADDR/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/K8S_IP_ADDR_HERE/$K8S_IP_ADDR/g" {} \;

##################
# Authentication #
##################
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_USERNAME_HERE/$OPENSTACK_USERNAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_TENANT_ID_HERE/$OPENSTACK_TENANT_ID/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_TENANT_NAME_HERE/$OPENSTACK_TENANT_NAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_PASSWORD_HERE/$OPENSTACK_API_KEY/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_REGION_HERE/$OPENSTACK_REGION/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,OPENSTACK_KEYSTONE_IP_HERE,$OPENSTACK_KEYSTONE_URL,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_SERVICE_TENANT_NAME_HERE/$OPENSTACK_SERVICE_TENANT_NAME/g" {} \;

###########
# Flavors #
###########
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_FLAVOUR_SMALL_HERE/$OPENSTACK_FLAVOUR_SMALL/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_FLAVOUR_MEDIUM_HERE/$OPENSTACK_FLAVOUR_MEDIUM/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_FLAVOUR_XLARGE_HERE/$OPENSTACK_FLAVOUR_XLARGE/g" {} \;

########
# ONAP #
########
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DMAAP_TOPIC_HERE/$DMAAP_TOPIC/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DEMO_ARTIFACTS_VERSION_HERE/$DEMO_ARTIFACTS_VERSION/g" {} \;
# SDNC/Robot preload files manipulation
OPENSTACK_OAM_NETWORK_CIDR_PREFIX=`cut -d. -f1-3 <<<"$OPENSTACK_OAM_NETWORK_CIDR"`
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE/$OPENSTACK_OAM_NETWORK_CIDR_PREFIX/g" {} \;
# MSO post install steps to encrypt openstack password
MSO_ENCRYPTION_KEY=$(cat /config-init/$NAMESPACE/mso/mso/encryption.key)
OPENSTACK_API_ENCRYPTED_KEY=`echo -n "$OPENSTACK_API_KEY" | openssl aes-128-ecb -e -K $MSO_ENCRYPTION_KEY -nosalt | xxd -c 256 -p`
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_ENCRYPTED_PASSWORD_HERE/$OPENSTACK_API_ENCRYPTED_KEY/g" {} \;

########
# DCAE #
########
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DCAE_VM_BASE_NAME_HERE/$DCAE_VM_BASE_NAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,DCAE_KEYSTONE_URL_HERE,$DCAE_KEYSTONE_URL,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,DCAE_DOMAIN_HERE,$DCAE_DOMAIN,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,DCAE_DOCKER_VERSION_HERE,$DCAE_DOCKER_VERSION,g" {} \;

###########
# KeyPair #
###########
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/OPENSTACK_KEY_NAME_HERE/$OPENSTACK_KEY_NAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,OPENSTACK_PUB_KEY_HERE,$OPENSTACK_PUB_KEY,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,OPENSTACK_PRIVATE_KEY_HERE,$OPENSTACK_PRIVATE_KEY,g" {} \;

#######
# DNS #
#######
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNS_LIST_HERE/$DNS_LIST/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/EXTERNAL_DNS_HERE/$EXTERNAL_DNS/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNS_FORWARDER_HERE/$DNS_FORWARDER/g" {} \;

#################
# DNS Designate #
#################
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNSAAS_PROXY_ENABLE_HERE/$DNSAAS_PROXY_ENABLE/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNSAAS_REGION_HERE/$DNSAAS_REGION/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s,DNSAAS_KEYSTONE_URL_HERE,$DNSAAS_KEYSTONE_URL,g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNSAAS_TENANT_NAME_HERE/$DNSAAS_TENANT_NAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNSAAS_USERNAME_HERE/$DNSAAS_USERNAME/g" {} \;
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/DNSAAS_PASSWORD_HERE/$DNSAAS_PASSWORD/g" {} \;


echo "Done!"
