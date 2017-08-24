#!/bin/bash
#make NAMESPACE directory
mkdir -p /config-init/$NAMESPACE/

#unzip the configs in the NAMESPACEs directory ensuring no overwriting of files
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
mkdir -p /config-init/$NAMESPACE/log/elasticsearch/data


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

chmod -R 777 /config-init/$NAMESPACE/log/elasticsearch


# replace the default 'onap' namespace qualification of K8s hostnames within the config files
find /config-init/$NAMESPACE/ -type f -exec sed -i -e "s/\.onap-/\.$NAMESPACE-/g" {} \;
