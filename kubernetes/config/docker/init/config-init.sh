#!/bin/bash
#make owner directory
mkdir -p /config-init/$OWNER/

#unzip the configs in the owners directory ensuring no overwriting of files
cp -vnpr /opt/config/src/* /config-init/$OWNER/

#ensure db directories exist.
mkdir -p /config-init/$OWNER/appc/data/
mkdir -p /config-init/$OWNER/dcae/pgaas/pgdata/
mkdir -p /config-init/$OWNER/portal/mariadb/data/
mkdir -p /config-init/$OWNER/sdnc/data/
mkdir -p /config-init/$OWNER/vid/mariadb/data/
mkdir -p /config-init/$OWNER/sdc/sdc-cs/CS/
mkdir -p /config-init/$OWNER/sdc/sdc-es/ES/
mkdir -p /config-init/$OWNER/sdc/logs/ASDC/ASDC-ES/
mkdir -p /config-init/$OWNER/sdc/logs/ASDC/ASDC-CS/
mkdir -p /config-init/$OWNER/sdc/logs/ASDC/ASDC-KB/
mkdir -p /config-init/$OWNER/sdc/logs/ASDC/ASDC-BE/
mkdir -p /config-init/$OWNER/sdc/logs/ASDC/ASDC-FE/
mkdir -p /config-init/$OWNER/aai/opt/aai/logroot/

chmod -R 777 /config-init/$OWNER/sdc/logs/
chmod -R 777 /config-init/$OWNER/aai/aai-config/
chmod -R 777 /config-init/$OWNER/aai/aai-data/
chmod -R 777 /config-init/$OWNER/aai/opt/aai/logroot/
