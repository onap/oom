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
[[ -z "$OPENSTACK_UBUNTU_14_IMAGE" ]] && { echo "Error: OPENSTACK_UBUNTU_14_IMAGE must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_PUBLIC_NET_ID" ]] && { echo "Error: OPENSTACK_PUBLIC_NET_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_OAM_NETWORK_ID" ]] && { echo "Error: OPENSTACK_OAM_NETWORK_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_OAM_SUBNET_ID" ]] && { echo "Error: OPENSTACK_OAM_SUBNET_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_OAM_NETWORK_CIDR" ]] && { echo "Error: OPENSTACK_OAM_NETWORK_CIDR must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_USERNAME" ]] && { echo "Error: OPENSTACK_USERNAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_ID" ]] && { echo "Error: OPENSTACK_TENANT_ID must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_API_KEY" ]] && { echo "Error: OPENSTACK_API_KEY must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_REGION" ]] && { echo "Error: OPENSTACK_REGION must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_KEYSTONE_URL" ]] && { echo "Error: OPENSTACK_KEYSTONE_URL must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_FLAVOUR_MEDIUM" ]] && { echo "Error: OPENSTACK_FLAVOUR_MEDIUM must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_SERVICE_TENANT_NAME" ]] && { echo "Error: OPENSTACK_SERVICE_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DMAAP_TOPIC" ]] && { echo "Error: DMAAP_TOPIC must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$DEMO_ARTIFACTS_VERSION" ]] && { echo "Error: DEMO_ARTIFACTS_VERSION must be set in onap-parameters.yaml"; exit 1; }
[[ -z "$OPENSTACK_TENANT_NAME" ]] && { echo "Error: OPENSTACK_TENANT_NAME must be set in onap-parameters.yaml"; exit 1; }

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
mkdir -p /config-init/$NAMESPACE/aai/haproxy/log/
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
OPENSTACK_API_ENCRYPTED_KEY=`echo -n "$OPENSTACK_API_KEY" | openssl aes-128-ecb -e -K $MSO_ENCRYPTION_KEY -nosalt | xxd -c 256 -p`

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
SED_CONFIG_PATHS="/config-init/$NAMESPACE/robot/ /config-init/$NAMESPACE/mso/"
SED_CONFIG_STRINGS=( \
  "s/UBUNTU_14_IMAGE_NAME_HERE/${OPENSTACK_UBUNTU_14_IMAGE}/g" \
  "s/OPENSTACK_PUBLIC_NET_ID_HERE/${OPENSTACK_PUBLIC_NET_ID}/g" \
  "s/OPENSTACK_NETWORK_ID_WITH_ONAP_ROUTE_HERE/${OPENSTACK_OAM_NETWORK_ID}/g" \
  "s/OPENSTACK_SUBNET_ID_WITH_ONAP_ROUTE_HERE/${OPENSTACK_OAM_SUBNET_ID}/g" \
  "s,NETWORK_CIDR_WITH_ONAP_ROUTE_HERE,${OPENSTACK_OAM_NETWORK_CIDR},g" \
  "s/OPENSTACK_USERNAME_HERE/${OPENSTACK_USERNAME}/g" \
  "s/OPENSTACK_TENANT_ID_HERE/${OPENSTACK_TENANT_ID}/g" \
  "s/OPENSTACK_PASSWORD_HERE/${OPENSTACK_API_KEY}/g" \
  "s/OPENSTACK_REGION_HERE/${OPENSTACK_REGION}/g" \
  "s,OPENSTACK_KEYSTONE_IP_HERE,${OPENSTACK_KEYSTONE_URL},g" \
  "s/OPENSTACK_FLAVOUR_MEDIUM_HERE/${OPENSTACK_FLAVOUR_MEDIUM}/g" \
  "s/DMAAP_TOPIC_HERE/${DMAAP_TOPIC}/g" \
  "s/OPENSTACK_SERVICE_TENANT_NAME_HERE/${OPENSTACK_SERVICE_TENANT_NAME}/g" \
  "s/DEMO_ARTIFACTS_VERSION_HERE/${DEMO_ARTIFACTS_VERSION}/g" \
  "s/OPENSTACK_OAM_NETWORK_CIDR_PREFIX_HERE/${OPENSTACK_OAM_NETWORK_CIDR_PREFIX}/g" \
  "s/OPENSTACK_ENCRYPTED_PASSWORD_HERE/${OPENSTACK_API_ENCRYPTED_KEY}/g" \
  "s/OPENSTACK_TENANT_NAME_HERE/${OPENSTACK_TENANT_NAME}/g" \
)
SED_CONFIG_STRING=$(concat_array "${SED_CONFIG_STRINGS[@]}")
find $SED_CONFIG_PATHS -type f -exec sed -i -e "${SED_CONFIG_STRING}" {} \;

echo "Done!"
