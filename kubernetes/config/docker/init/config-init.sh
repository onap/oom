#!/bin/bash -x

concat_array() {
  local arr=("$@")
  local str=''
  for i in ${!arr[@]}; do
    if (( $i > 0 )); then
      str="${str};"
    fi
    str="${str}${arr[$i]}"
  done
  echo "$str"
}

echo "Validating onap-parameters.yaml has been populated"

[[ -z "$NEXUS_HTTP_REPO" ]] && { echo "Error: NEXUS_HTTP_REPO must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$NEXUS_DOCKER_REPO" ]] && { echo "Error: NEXUS_DOCKER_REPO must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$NEXUS_USERNAME" ]] && { echo "Error: NEXUS_USERNAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$NEXUS_PASSWORD" ]] && { echo "Error: NEXUS_PASSWORD must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$OPENSTACK_USERNAME" ]] && { echo "Error: OPENSTACK_USERNAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_PASSWORD" ]] && { echo "Error: OPENSTACK_PASSWORD must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_NAME" ]] && { echo "Error: OPENSTACK_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_ID" ]] && { echo "Error: OPENSTACK_TENANT_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_REGION" ]] && { echo "Error: OPENSTACK_REGION must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_API_VERSION" ]] && { echo "Error: OPENSTACK_API_VERSION must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_KEYSTONE_URL" ]] && { echo "Error: OPENSTACK_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_SERVICE_TENANT_NAME" ]] && { echo "Error: OPENSTACK_SERVICE_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$DMAAP_TOPIC" ]] && { echo "Error: DMAAP_TOPIC must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DEMO_ARTIFACTS_VERSION" ]] && { echo "Error: DEMO_ARTIFACTS_VERSION must be set in onap-parameters.yaml"; exit 1; }

[[ -z "$DEPLOY_DCAE" ]] && { echo "Error: DEPLOY_DCAE must be set in onap-parameters.yaml"; exit 1; }
if [ "$DEPLOY_DCAE" = "true" ]
then
    [[ -z "$DCAE_VM_BASE_NAME" ]] && { echo "Error: DCAE_VM_BASE_NAME must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_DOCKER_VERSION" ]] && { echo "Error: DCAE_DOCKER_VERSION must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$IS_SAME_OPENSTACK_AS_VNF" ]] && { echo "Error: IS_SAME_OPENSTACK_AS_VNF must be set in onap-parameters.yaml"; exit 1; }
    if [ "$IS_SAME_OPENSTACK_AS_VNF" = "false" ]
    then
        [[ -z "$DCAE_OS_API_VERSION" ]] && { echo "Error: DCAE_OS_API_VERSION must be set in onap-parameters.yaml"; exit 1; }
        [[ -z "$DCAE_OS_KEYSTONE_URL" ]] && { echo "Error: DCAE_OS_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
        [[ -z "$DCAE_OS_USERNAME" ]] && { echo "Error: DCAE_OS_USERNAME must be set in onap-parameters.yaml"; exit 1; }
        [[ -z "$DCAE_OS_PASSWORD" ]] && { echo "Error: DCAE_OS_PASSWORD must be set in onap-parameters.yaml"; exit 1; }
        [[ -z "$DCAE_OS_TENANT_NAME" ]] && { echo "Error: DCAE_OS_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }
        [[ -z "$DCAE_OS_TENANT_ID" ]] && { echo "Error: DCAE_OS_TENANT_ID must be set in onap-parameters.yaml"; exit 1; }
        [[ -z "$DCAE_OS_REGION" ]] && { echo "Error: DCAE_OS_REGION must be set in onap-parameters.yaml"; exit 1; }
    fi

    [[ -z "$DCAE_OS_PUBLIC_NET_ID" ]] && { echo "Error: DCAE_OS_PUBLIC_NET_ID must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_PUBLIC_NET_NAME" ]] && { echo "Error: DCAE_OS_PUBLIC_NET_NAME must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_OAM_NETWORK_CIDR" ]] && { echo "Error: DCAE_OS_OAM_NETWORK_CIDR must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_IP_ADDR" ]] && { echo "Error: DCAE_IP_ADDR must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$DCAE_OS_FLAVOR_SMALL" ]] && { echo "Error: DCAE_OS_FLAVOR_SMALL must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_FLAVOR_MEDIUM" ]] && { echo "Error: DCAE_OS_FLAVOR_MEDIUM must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_FLAVOR_LARGE" ]] && { echo "Error: DCAE_OS_FLAVOR_LARGE must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$DCAE_OS_UBUNTU_14_IMAGE" ]] && { echo "Error: DCAE_OS_UBUNTU_14_IMAGE must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_UBUNTU_16_IMAGE" ]] && { echo "Error: DCAE_OS_UBUNTU_16_IMAGE must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_CENTOS_7_IMAGE" ]] && { echo "Error: DCAE_OS_CENTOS_7_IMAGE must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$DCAE_OS_KEY_NAME" ]] && { echo "Error: DCAE_OS_KEY_NAME must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_PUB_KEY" ]] && { echo "Error: DCAE_OS_PUB_KEY must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DCAE_OS_PRIVATE_KEY" ]] && { echo "Error: DCAE_OS_PRIVATE_KEY must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$DNS_IP" ]] && { echo "Error: DNS_LIST must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNS_FORWARDER" ]] && { echo "Error: DNS_FORWARDER must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$EXTERNAL_DNS" ]] && { echo "Error: EXTERNAL_DNS must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$DCAE_DOMAIN" ]] && { echo "Error: DCAE_DOMAIN must be set in onap-parameters.yaml"; exit 1; }

    [[ -z "$DNSAAS_PROXY_ENABLE" ]] && { echo "Error: DNSAAS_PROXY_ENABLE must be set in onap-parameters.yaml"; exit 1; }
    if [ "$$DNSAAS_PROXY_ENABLE" = "true" ]
    then
        [[ -z "$DCAE_PROXIED_KEYSTONE_URL" ]] && { echo "Error: DCAE_PROXIED_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
    fi
    [[ -z "$DNSAAS_API_VERSION" ]] && { echo "Error: DNSAAS_API_VERSION must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNSAAS_REGION" ]] && { echo "Error: DNSAAS_REGION must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNSAAS_KEYSTONE_URL" ]] && { echo "Error: DNSAAS_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNSAAS_TENANT_ID" ]] && { echo "Error: DNSAAS_TENANT_ID must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNSAAS_TENANT_NAME" ]] && { echo "Error: DNSAAS_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNSAAS_USERNAME" ]] && { echo "Error: DNSAAS_USERNAME must be set in onap-parameters.yaml"; exit 1; }
    [[ -z "$DNSAAS_PASSWORD" ]] && { echo "Error: DNSAAS_PASSWORD must be set in onap-parameters.yaml"; exit 1; }
fi

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

# SDNC/Robot preload files manipulation
OPENSTACK_OAM_NETWORK_CIDR_PREFIX=`cut -d. -f1-3 <<<"$OPENSTACK_OAM_NETWORK_CIDR"`

# MSO post install steps to encrypt openstack password
MSO_ENCRYPTION_KEY=$(cat /config-init/$NAMESPACE/mso/mso/encryption.key)
OPENSTACK_API_ENCRYPTED_KEY=`echo -n "$OPENSTACK_PASSWORD" | openssl aes-128-ecb -e -K $MSO_ENCRYPTION_KEY -nosalt | xxd -c 256 -p`

echo "Substituting configuration parameters"

# replace the default 'onap' namespace qualification of K8s hostnames within the config files
SED_NS_PATHS="/config-init/$NAMESPACE/"
SED_NS_STRINGS=(
  "s/\.onap-/\.${NAMESPACE}-/g"
  "s/kubectl -n onap/kubectl -n ${NAMESPACE}/g"
)
SED_NS_STRING=$(concat_array "${SED_NS_STRINGS[@]}")
find $SED_NS_PATHS -type f -exec sed -i -e "${SED_NS_STRING}" {} \;

# set variable parameters
# ATTENTION: the list of the paths must be verified if more parameters are added!
SED_CONFIG_PATHS="/config-init/$NAMESPACE/robot/ /config-init/$NAMESPACE/mso/ /config-init/$NAMESPACE/dcaegen2/heat/"
SED_CONFIG_STRINGS=( \
  "s,NEXUS_HTTP_REPO_HERE,$NEXUS_HTTP_REPO,g" \
  "s,NEXUS_DOCKER_REPO_HERE,$NEXUS_DOCKER_REPO,g" \
  "s/NEXUS_USERNAME_HERE/$NEXUS_USERNAME/g" \
  "s/NEXUS_PASSWORD_HERE/$NEXUS_PASSWORD/g" \
  "s/DMAAP_TOPIC_HERE/${DMAAP_TOPIC}/g" \
  "s/DEMO_ARTIFACTS_VERSION_HERE/${DEMO_ARTIFACTS_VERSION}/g" \
  "s/OPENSTACK_USERNAME_HERE/${OPENSTACK_USERNAME}/g" \
  "s/OPENSTACK_TENANT_ID_HERE/${OPENSTACK_TENANT_ID}/g" \
  "s/OPENSTACK_TENANT_NAME_HERE/$OPENSTACK_TENANT_NAME/g" \
  "s/OPENSTACK_PASSWORD_HERE/${OPENSTACK_PASSWORD}/g" \
  "s/OPENSTACK_REGION_HERE/${OPENSTACK_REGION}/g" \
  "s,OPENSTACK_KEYSTONE_IP_HERE,${OPENSTACK_KEYSTONE_URL},g" \
  "s,OPENSTACK_API_VERSION_HERE,$OPENSTACK_API_VERSION,g" \
  "s/OPENSTACK_SERVICE_TENANT_NAME_HERE/$OPENSTACK_SERVICE_TENANT_NAME/g" \
  "s/OPENSTACK_ENCRYPTED_PASSWORD_HERE/${OPENSTACK_API_ENCRYPTED_KEY}/g" \
  "s/VNF_OPENSTACK_OAM_NETWORK_ID_HERE/$OPENSTACK_OAM_NETWORK_ID/g" \
  "s/VNF_OPENSTACK_PUBLIC_ID_HERE/$OPENSTACK_PUBLIC_NETWORK_ID/g" \
  "s/VNF_OPENSTACK_FLAVOR_HERE/$OPENSTACK_FLAVOR/g" \
  "s/VNF_OPENSTACK_IMAGE_HERE/$OPENSTACK_IMAGE/g" \
)
SED_CONFIG_STRING=$(concat_array "${SED_CONFIG_STRINGS[@]}")
find $SED_CONFIG_PATHS -type f -exec sed -i -e "${SED_CONFIG_STRING}" {} \;

if [ "$DEPLOY_DCAE" = "true" ]
then
    SED_CONFIG_PATHS="/config-init/$NAMESPACE/dcaegen2/heat/"
    SED_CONFIG_STRINGS=( \
      "s,DCAE_IP_ADDR_HERE,$DCAE_IP_ADDR,g" \
      "s,DCAE_VM_BASE_NAME_HERE,$DCAE_VM_BASE_NAME,g" \
      "s,DCAE_DOCKER_VERSION_HERE,$DCAE_DOCKER_VERSION,g" \
      "s,DCAE_OS_PUBLIC_NET_ID_HERE,$DCAE_OS_PUBLIC_NET_ID,g" \
      "s,DCAE_OS_PUBLIC_NET_NAME_HERE,$DCAE_OS_PUBLIC_NET_NAME,g" \
      "s,DCAE_OS_OAM_NETWORK_CIDR_HERE,$DCAE_OS_OAM_NETWORK_CIDR,g" \
      "s,DCAE_IP_ADDR_HERE,$DCAE_IP_ADDR,g" \
      "s,DCAE_DOMAIN_HERE,$DCAE_DOMAIN,g" \
      "s,OPENSTACK_FLAVOR_SMALL_HERE,$DCAE_OS_FLAVOR_SMALL,g" \
      "s,OPENSTACK_FLAVOR_MEDIUM_HERE,$DCAE_OS_FLAVOR_MEDIUM,g" \
      "s,OPENSTACK_FLAVOR_LARGE_HERE,$DCAE_OS_FLAVOR_LARGE,g" \
      "s,UBUNTU_14_IMAGE_NAME_HERE,$DCAE_OS_UBUNTU_14_IMAGE,g" \
      "s,UBUNTU_16_IMAGE_NAME_HERE,$DCAE_OS_UBUNTU_16_IMAGE,g" \
      "s,OPENSTACK_CENTOS_7_IMAGE_HERE,$DCAE_OS_CENTOS_7_IMAGE,g" \
      "s,OPENSTACK_KEY_NAME_HERE,$DCAE_OS_KEY_NAME,g" \
      "s,OPENSTACK_PUB_KEY_HERE,$DCAE_OS_PUB_KEY,g" \
      "s,OPENSTACK_PRIVATE_KEY_HERE,$DCAE_OS_PRIVATE_KEY,g" \
      "s,DNS_LIST_HERE,$DNS_IP,g" \
      "s,EXTERNAL_DNS_HERE,$EXTERNAL_DNS,g" \
      "s,DNS_FORWARDER_HERE,$DNS_FORWARDER,g" \
      "s,DNSAAS_API_VERSION_HERE,$DNSAAS_API_VERSION,g" \
      "s,DNSAAS_REGION_HERE,$DNSAAS_REGION,g" \
      "s,DNSAAS_KEYSTONE_URL_HERE,$DNSAAS_KEYSTONE_URL,g" \
      "s,DNSAAS_TENANT_NAME_HERE,$DNSAAS_TENANT_NAME,g" \
      "s,DNSAAS_TENANT_ID_HERE,$DNSAAS_TENANT_ID,g" \
      "s,DNSAAS_USERNAME_HERE,$DNSAAS_USERNAME,g" \
      "s,DNSAAS_PASSWORD_HERE,$DNSAAS_PASSWORD,g" \
    )
    SED_CONFIG_STRING=$(concat_array "${SED_CONFIG_STRINGS[@]}")
    find $SED_CONFIG_PATHS -type f -exec sed -i -e "${SED_CONFIG_STRING}" {} \;

    if [ "$IS_SAME_OPENSTACK_AS_VNF" = "false" ]
    then
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_USERNAME_HERE/$DCAE_OS_USERNAME/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_PASSWORD_HERE/$DCAE_OS_PASSWORD/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_TENANT_NAME_HERE/$DCAE_OS_TENANT_NAME/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_TENANT_ID_HERE/$DCAE_OS_TENANT_ID/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_REGION_HERE/$DCAE_OS_REGION/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_API_VERSION_HERE/$DCAE_OS_API_VERSION/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s,DCAE_OS_KEYSTONE_URL_HERE,$DCAE_OS_KEYSTONE_URL,g" {} \;
    else
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_USERNAME_HERE/$OPENSTACK_USERNAME/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_PASSWORD_HERE/$OPENSTACK_PASSWORD/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_TENANT_NAME_HERE/$OPENSTACK_TENANT_NAME/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_TENANT_ID_HERE/$OPENSTACK_TENANT_ID/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_REGION_HERE/$OPENSTACK_REGION/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DCAE_OS_API_VERSION_HERE/$OPENSTACK_API_VERSION/g" {} \;
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s,DCAE_OS_KEYSTONE_URL_HERE,$OPENSTACK_KEYSTONE_URL,g" {} \;
    fi

    #################
    # DNS Designate #
    #################
    find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s/DNSAAS_PROXY_ENABLE_HERE/$DNSAAS_PROXY_ENABLE/g" {} \;
    if [ "$DNSAAS_PROXY_ENABLE" = "true" ]
    then
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s,DCAE_FINAL_KEYSTONE_URL_HERE,$DCAE_PROXIED_KEYSTONE_URL,g" {} \;
    elif [ "$IS_SAME_OPENSTACK_AS_VNF" = "false" ]
    then
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s,DCAE_FINAL_KEYSTONE_URL_HERE,$DCAE_OS_KEYSTONE_URL/$DCAE_OS_API_VERSION,g" {} \;
    else
        find /config-init/$NAMESPACE/dcaegen2/heat/ -type f -exec sed -i -e "s,DCAE_FINAL_KEYSTONE_URL_HERE,$OPENSTACK_KEYSTONE_URL/$OPENSTACK_API_VERSION,g" {} \;
    fi
fi

# Install kube-dns ip in the nginx conf
KUBE_DNS_IP=`kubectl get service -n kube-system kube-dns -o jsonpath='{.spec.clusterIP}'`
find /config-init/$NAMESPACE/dcaegen2/nginx/ -type f -exec sed -i -e "s/KUBE_DNS_IP_HERE/$KUBE_DNS_IP/g" {} \;

# Inject node ip for UEB config
# There is actually two places where we need to inject this list, and one required to list to be comma seperated and quote separated,
# and one requires to be only quote seperated.
UEB_ADDR_IP=$(kubectl get nodes -o jsonpath='{ $.items[*].status.addresses[?(@.type=="ExternalIP")].address }')

# As SDC is expecting a cluster of UEB, there is a need to have at least two entries. If we have only one, we duplicate it.
# Also, this list has to be comma seperated.
if [ `echo $UEB_ADDR_IP | wc -w` -gt "1" ]
then
    UEB_ADDR_IP_COMMA_AND_QUOTE_SEPERATED=`echo $UEB_ADDR_IP | sed 's/ /","/g'`
    UEB_ADDR_IP_COMMA_SEPERATED=`echo $UEB_ADDR_IP | sed 's/ /,/g'`
else
    UEB_ADDR_IP_COMMA_AND_QUOTE_SEPERATED="$UEB_ADDR_IP\",\"$UEB_ADDR_IP"
    UEB_ADDR_IP_COMMA_SEPERATED="$UEB_ADDR_IP,$UEB_ADDR_IP"
fi

sed -i -e "s/UEB_ADDR_IP_COMMA_AND_QUOTE_SEPERATED_HERE/$UEB_ADDR_IP_COMMA_AND_QUOTE_SEPERATED/g" /config-init/$NAMESPACE/sdc/environments/AUTO.json
sed -i -e "s/UEB_ADDR_IP_COMMA_SEPERATE_HERE/$UEB_ADDR_IP_COMMA_SEPERATED/g" /config-init/$NAMESPACE/sdc/environments/AUTO.json


echo "Done!"
