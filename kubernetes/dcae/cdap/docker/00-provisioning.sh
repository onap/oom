#!/bin/bash
set -x

export DEBIAN_FRONTEND=noninteractive

##############################################################
################### File provisioning ########################
##############################################################

cd /tmp


## Adding configuration file: mount_config
cat > /tmp/dcae-mount.conf << EOF_CONFIG
osType: ubuntu
volumes:
  ephemeral:
    uuid: ephemeral
    size: 80
    filesystems:
      /opt/tools:
        size: 80
        type: ext4
        mount_opts: ''
  data:
    uuid: cinder
    size: 75
    filesystems:
      /opt/data:
        size: 75
        type: ext4
        mount_opts: ''
EOF_CONFIG


## Adding configuration file: ecomp-nexus
cat > /tmp/ecomp-nexus.crt << EOF_CONFIG
-----BEGIN CERTIFICATE-----
MIIFRTCCBC2gAwIBAgIQM/5eM8D0jY3yHTSyN5iO9zANBgkqhkiG9w0BAQsFADCB
kDELMAkGA1UEBhMCR0IxGzAZBgNVBAgTEkdyZWF0ZXIgTWFuY2hlc3RlcjEQMA4G
A1UEBxMHU2FsZm9yZDEaMBgGA1UEChMRQ09NT0RPIENBIExpbWl0ZWQxNjA0BgNV
BAMTLUNPTU9ETyBSU0EgRG9tYWluIFZhbGlkYXRpb24gU2VjdXJlIFNlcnZlciBD
QTAeFw0xNzAzMjgwMDAwMDBaFw0xODAzMjgyMzU5NTlaMFcxITAfBgNVBAsTGERv
bWFpbiBDb250cm9sIFZhbGlkYXRlZDEdMBsGA1UECxMUUG9zaXRpdmVTU0wgV2ls
ZGNhcmQxEzARBgNVBAMMCioub25hcC5vcmcwggEiMA0GCSqGSIb3DQEBAQUAA4IB
DwAwggEKAoIBAQDIVo+kmG2sGaeIJy5pqP6mzlIwqYUXcFOG2fodsCPg9CEdlsBO
IECuoPYmCqrJ/MHLfs+F+SjEoBfpJlqyrpLhVj8O/9xCp4Tda/YJ18n59uDJ7Rpq
omqZlFCj/B4+H6+dkWCFy1FxYBBAIO52iscd4F6YHD1p3xUjJRd9Yf6qnktmSooI
hbIKzPIpSTsYiN3ArWbrGeucoQUdKX+intRHFLkKay88R7yqoqguPFIEtkXwDoJj
aV+rC103eZ1RLwtBcS/4UcDXRDfkyQANAYvKGeHiyGuRQqEUyGEmKz2i11m1oyEP
uD1AK+zPd33wBdOe8iZMr0CxcOGhgcKOWJ7vAgMBAAGjggHRMIIBzTAfBgNVHSME
GDAWgBSQr2o6lFoL2JDqElZz30O0Oija5zAdBgNVHQ4EFgQUMVkz3DD9qwhzY5WT
/P1mCVpsauQwDgYDVR0PAQH/BAQDAgWgMAwGA1UdEwEB/wQCMAAwHQYDVR0lBBYw
FAYIKwYBBQUHAwEGCCsGAQUFBwMCME8GA1UdIARIMEYwOgYLKwYBBAGyMQECAgcw
KzApBggrBgEFBQcCARYdaHR0cHM6Ly9zZWN1cmUuY29tb2RvLmNvbS9DUFMwCAYG
Z4EMAQIBMFQGA1UdHwRNMEswSaBHoEWGQ2h0dHA6Ly9jcmwuY29tb2RvY2EuY29t
L0NPTU9ET1JTQURvbWFpblZhbGlkYXRpb25TZWN1cmVTZXJ2ZXJDQS5jcmwwgYUG
CCsGAQUFBwEBBHkwdzBPBggrBgEFBQcwAoZDaHR0cDovL2NydC5jb21vZG9jYS5j
b20vQ09NT0RPUlNBRG9tYWluVmFsaWRhdGlvblNlY3VyZVNlcnZlckNBLmNydDAk
BggrBgEFBQcwAYYYaHR0cDovL29jc3AuY29tb2RvY2EuY29tMB8GA1UdEQQYMBaC
Cioub25hcC5vcmeCCG9uYXAub3JnMA0GCSqGSIb3DQEBCwUAA4IBAQAd5mu22sts
at/bdRlIOz3dbqGwIFOo8XajlAs6ApMpyx/xetcgIKipzvGp9Wc1X8lDZl4boCH6
KQ1//4tpksYj8RsZSZeac8vQLKggWO107sBa33yFg6Y1Dk2DdgOKZ+lNbvB1iMwK
hSGtV3HYx1jLyQRoeYby4R7+kTI1lHAiOgT+vn5C9Z3TxqfgWuBf24CFp/95gki6
vRysJh9Jf7A8JrrMGykC94Tpo6OiUehtQ+f65xtetvwsfNHVp3hsLzR5KwIMDARI
IgXKyROodILsOXfR9qdA9klcXUSi6qvKF8wAopNuot4Ltyz8chiFKISjxqVrKnY2
M7En/HyX0s1I
-----END CERTIFICATE-----
EOF_CONFIG


## Adding configuration file: vm-cdap-cluster-cdap.properties
cat > /tmp/vm-cdap-cluster-cdap.properties << EOF_CONFIG
cluster.endpoint= foobar
cluster.user= foobar
cluster.password= foobar
EOF_CONFIG


## Adding configuration file: vm-cdap-cluster-console.properties
cat > /tmp/vm-cdap-cluster-console.properties << EOF_CONFIG
localhost.endpoint=http://localhost:1999
localhost.user=console
localhost.password=NTJhYWU1NzAwMzc3OTk1
EOF_CONFIG


## Adding configuration file: vm-cdap-cluster-gui.properties
cat > /tmp/vm-cdap-cluster-gui.properties << EOF_CONFIG
EOF_CONFIG


## Adding configuration file: vm-cdap-cluster-log4j.properties
cat > /tmp/vm-cdap-cluster-log4j.properties << EOF_CONFIG
#log4j.debug=0
log4j.rootLogger=warn, file
log4j.logger.org.openecomp.ncomp=info, file
log4j.additivity.org.openecomp.ncomp=false

#log4j.logger.org.apache.http.headers=debug, file
#log4j.logger.org.apache.http.wire=debug, file
## uploaded logger
log4j.logger.org.openecomp.ncomp.sirius.manager.uploaded=info, uploaded
log4j.additivity.org.openecomp.ncomp.sirius.manager.uploaded=false
## request logging
log4j.logger.org.openecomp.ncomp.sirius.manager.ManagementServer.requests=info, requests
log4j.additivity.org.openecomp.ncomp.sirius.manager.ManagementServer.requests=false
## openstack polling
log4j.logger.org.openecomp.ncomp.openstack.OpenStackUtil.polling=info, polling
log4j.additivity.org.openecomp.ncomp.openstack.OpenStackUtil.polling=false
log4j.appender.file=org.apache.log4j.RollingFileAppender
log4j.appender.file.File=logs/manager.log
log4j.appender.file.layout=org.apache.log4j.PatternLayout
log4j.appender.file.layout.ConversionPattern=%d %5p [%t] %m %C:%L%n
log4j.appender.file.MaxFileSize=50MB
log4j.appender.file.MaxBackupIndex=5

log4j.appender.uploaded=org.apache.log4j.RollingFileAppender
log4j.appender.uploaded.File=logs/manager-uploaded.log
log4j.appender.uploaded.layout=org.apache.log4j.PatternLayout
log4j.appender.uploaded.layout.ConversionPattern=%d %5p [%t] %m %C:%L%n
log4j.appender.uploaded.MaxFileSize=50MB
log4j.appender.uploaded.MaxBackupIndex=5

log4j.appender.requests=org.apache.log4j.RollingFileAppender
log4j.appender.requests.File=logs/manager-requests.log
log4j.appender.requests.layout=org.apache.log4j.PatternLayout
log4j.appender.requests.layout.ConversionPattern=%d %5p [%t] %m %C:%L%n
log4j.appender.requests.MaxFileSize=50MB
log4j.appender.requests.MaxBackupIndex=5
log4j.appender.polling=org.apache.log4j.RollingFileAppender
log4j.appender.polling.File=logs/manager-polling.log
log4j.appender.polling.layout=org.apache.log4j.PatternLayout
log4j.appender.polling.layout.ConversionPattern=%d %5p [%t] %m %C:%L%n
log4j.appender.polling.MaxFileSize=50MB
log4j.appender.polling.MaxBackupIndex=5

### ECOMP Logging
log4j.logger.org.openecomp.audit=info, audit
log4j.additivity.org.openecomp.audit=false
log4j.logger.org.openecomp.metrics=info, metrics
log4j.additivity.org.openecomp.metrics=false
log4j.logger.org.openecomp.error=info, error
log4j.additivity.org.openecomp.error=false
log4j.logger.com.att.eelf.debug=info, debug
log4j.additivity.org.openecomp.debug=false
log4j.appender.audit=org.apache.log4j.RollingFileAppender
log4j.appender.audit.File=logs/audit.log
log4j.appender.audit.layout=org.apache.log4j.PatternLayout
log4j.appender.audit.layout.ConversionPattern=%d{MM/dd-HH:mm:ss.SSS}|%X{RequestId}|%X{ServiceInstanceId}|%t|%X{ServiceName}|%X{InstanceUUID}|%5p|%X{AlertSeverity}|%X{ServerIPAddress}|%X{ServerFQDN}|%X{RemoteHost}|%X{Timer}|%m%n
log4j.appender.audit.MaxFileSize=50MB
log4j.appender.audit.MaxBackupIndex=5
log4j.appender.metrics=org.apache.log4j.RollingFileAppender
log4j.appender.metrics.File=logs/metrics.log
log4j.appender.metrics.layout=org.apache.log4j.PatternLayout
log4j.appender.metrics.layout.ConversionPattern=%d{MM/dd-HH:mm:ss.SSS}|%X{RequestId}|%X{ServiceInstanceId}|%t|%X{ServiceName}|%X{InstanceUUID}|%p|%X{AlertSeverity}|%X{ServerIPAddress}|%X{ServerFQDN}|%X{RemoteHost}|%X{Timer}|%m%n
log4j.appender.metrics.MaxFileSize=50MB
log4j.appender.metrics.MaxBackupIndex=5
log4j.appender.error=org.apache.log4j.RollingFileAppender
log4j.appender.error.File=logs/error.log
log4j.appender.error.layout=org.apache.log4j.PatternLayout
log4j.appender.error.layout.ConversionPattern=%d{MM/dd-HH:mm:ss.SSS}|%X{RequestId}|%X{ServiceInstanceId}|%t|%X{ServiceName}|%X{InstanceUUID}|%p|%X{AlertSeverity}|%X{ServerIPAddress}|%X{ServerFQDN}|%X{RemoteHost}|%X{Timer}|%m%n
log4j.appender.error.MaxFileSize=50MB
log4j.appender.error.MaxBackupIndex=5
log4j.appender.debug=org.apache.log4j.RollingFileAppender
log4j.appender.debug.File=logs/debug.log
log4j.appender.debug.layout=org.apache.log4j.PatternLayout
log4j.appender.debug.layout.ConversionPattern=%d{MM/dd-HH:mm:ss.SSS}|%X{RequestId}|%X{ServiceInstanceId}|%t|%X{ServiceName}|%X{InstanceUUID}|%p|%X{AlertSeverity}|%X{ServerIPAddress}|%X{ServerFQDN}|%X{RemoteHost}|%X{Timer}|%m%n
log4j.appender.debug.MaxFileSize=50MB
log4j.appender.debug.MaxBackupIndex=5
EOF_CONFIG


## Adding configuration file: vm-cdap-cluster-manager.properties
cat > /tmp/vm-cdap-cluster-manager.properties << EOF_CONFIG
server.dir = data/resources
metrics.dir = data/metrics
properties.dir = data/properties
server.port = 1999
server.user.console = NTJhYWU1NzAwMzc3OTk1
server.user.gui = MDlhZWVjZWEwMmFiOTJi
server.user.client = YmE2OGE1N2U5NzRmMDg1
EOF_CONFIG


## Adding configuration file: vm-cdap-cluster-runtime.properties
cat > /tmp/vm-cdap-cluster-runtime.properties << EOF_CONFIG
factory.vm=org.openecomp.dcae.controller.service.servers.vm.DcaeVmFactory

## Adding configuration file: monitoring-agent-gui.properties
cat > /tmp/monitoring-agent-gui.properties << EOF_CONFIG
EOF_CONFIG


cat > /tmp/certificate.pkcs12.b64code << EOF_CERT
EOF_CERT


##############################################################
################## Config Provisioning #######################
##############################################################

mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBn8Ctt5hJGkTQaffuSeINeABV4viBIM4TcP14kaLiWR1LkyNY+TaUnjxODobtZa4YW1lxFtoMCfZt2A5W9ZZPM+shZr4BOj+wU+xIrzn7ezN/CQjH7c4Wh0mWteuPnJrtdpyGQ/qBI2T+xo5G/Tl++SPUvvN2D4H8vl0miEgVPR47/P7Ba6kl7Bmrf9m0VDPdS69Qr2AhgBq5Qi/fTeGZA4sfKDHHRJxkQIXYmS8R5FISRpBD7ta2NTHapRz9dC6Cw8UttEFiWFUBjN6lwF9LUOkj9MiqiTQaElKKQzMIHr0AhlgIkwBLKAJoDrGQD9GKPwKCdW3OmnODMPxJjXc3 > ~/.ssh/authorized_keys

cp /tmp/ecomp-nexus.crt /usr/local/share/ca-certificates/ ; update-ca-certificates

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-core-utils/1.1.0/dcae-controller-core-utils-1.1.0-runtime.zip -P /opt/app/dcae-controller-core-utils

cd /opt/app/dcae-controller-core-utils
unzip -o dcae-controller-core-utils*.zip

chown -R dcae:dcae /opt/app/dcae-controller-core-utils

/opt/app/dcae-controller-core-utils/bin/fs-init.py

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-service-cdap-cluster-manager/1.1.0/dcae-controller-service-cdap-cluster-manager-1.1.0-runtime.zip -P /opt/app/dcae-controller-service-cdap-cluster-manager

cd /opt/app/dcae-controller-service-cdap-cluster-manager
unzip -o dcae-controller-service-cdap-cluster-manager*.zip

chown -R dcae:dcae /opt/app/dcae-controller-service-cdap-cluster-manager

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-service-dmaap-drsub/1.1.0/dcae-controller-service-dmaap-drsub-1.1.0.pom -P /opt/app/dcae-controller-service-dmaap-drsub

chown -R dcae:dcae /opt/app/dcae-controller-service-dmaap-drsub

curl -s -k -f -o /tmp/dcae-apod-cdap-small-hadoop_1.1.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.apod.cdap/deb-releases/dcae-apod-cdap-small-hadoop_1.1.0.deb

curl -s -k -f -o /tmp/dcae-apod-analytics-tca_1.1.0.deb https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.apod.analytics/deb-releases/dcae-apod-analytics-tca_1.1.0.deb

curl -s -k -f -o /tmp/HelloWorld-3.5.1.jar http://repo1.maven.org/maven2/co/cask/cdap/HelloWorld/3.5.1/HelloWorld-3.5.1.jar
mkdir -p /opt/app/cask-hello-world/lib
mv /tmp/HelloWorld-3.5.1.jar /opt/app/cask-hello-world/lib

find /opt -type f -exec sed -i 's/sudo//g' {} \;

apt-key adv --keyserver-options --keyserver keyserver.ubuntu.com --recv 07513CAD
wget -qO - http://repository.cask.co/ubuntu/precise/amd64/cdap/3.5/pubkey.gpg | apt-key add -

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-service-dmaap-drsub-manager/1.1.0/dcae-controller-service-dmaap-drsub-manager-1.1.0-runtime.zip -P /opt/app/dcae-controller-service-dmaap-drsub-manager

cd /opt/app/dcae-controller-service-dmaap-drsub-manager
unzip -o dcae-controller-service-dmaap-drsub-manager-1.1.0-runtime.zip

chown -R dcae:dcae /opt/app/dcae-controller-service-dmaap-drsub-manager

mkdir /home/dcae/.ssh
chmod og-rwx /home/dcae/.ssh
chown -R dcae:dcae /home/dcae/.ssh
touch /home/dcae/.ssh/authorized_keys
chmod og-rwx /home/dcae/.ssh/authorized_keys
chown -R dcae:dcae /home/dcae/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDBn8Ctt5hJGkTQaffuSeINeABV4viBIM4TcP14kaLiWR1LkyNY+TaUnjxODobtZa4YW1lxFtoMCfZt2A5W9ZZPM+shZr4BOj+wU+xIrzn7ezN/CQjH7c4Wh0mWteuPnJrtdpyGQ/qBI2T+xo5G/Tl++SPUvvN2D4H8vl0miEgVPR47/P7Ba6kl7Bmrf9m0VDPdS69Qr2AhgBq5Qi/fTeGZA4sfKDHHRJxkQIXYmS8R5FISRpBD7ta2NTHapRz9dC6Cw8UttEFiWFUBjN6lwF9LUOkj9MiqiTQaElKKQzMIHr0AhlgIkwBLKAJoDrGQD9GKPwKCdW3OmnODMPxJjXc3 >> /home/dcae/.ssh/authorized_keys

#bash /opt/app/dcae-cdap-small-hadoop/install.sh
