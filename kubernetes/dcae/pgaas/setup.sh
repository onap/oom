#!/bin/bash
cat > /tmp/dcae_install.sh << EOF_DCAE_INSTALL
#!/bin/bash
set -x
cd /tmp

export DEBIAN_FRONTEND=noninteractive

#### Using special configuration resource: instances/vm-postgresql/iad4.yaml
## Adding configuration file: main
cat | cat > /tmp/postgres.conf << EOF_CONFIG
master:  zldciad4vipstg00
secondmaster: notused
DRTR_NODE_KSTOREFILE: /opt/app/dcae-certificate/keystore.jks
DRTR_NODE_KSTOREPASS: "No Certificate"
DRTR_NODE_PVTKEYPASS: "No Certificate"
PG_NODES : zldciad4vipstg00
PG_JAVA_HOME : /opt/app/java/jdk/jdk170
PG_CLUSTER : site
EOF_CONFIG

## Adding configuration file: mount_config
cat | cat > /tmp/dcae-mount.conf << EOF_CONFIG
osType: ubuntu
volumes:
  opt:
    uuid: ephemeral
    size: 80
    filesystems:
      /opt/tools:
        size: 80
        type: ext4
        mount_opts: ''
  dbroot:
    uuid: cinder
    size: 75
    filesystems:
      /dbroot/pgdata:
        size: 50
        type: ext4
        mount_opts: ''
      /dbroot/pglogs:
        size: 25
        type: ext4
        mount_opts: ''

EOF_CONFIG

## Adding configuration file: ecomp-nexus
cat > /tmp/ecomp-nexus.crt << EOF_CONFIG
-----BEGIN CERTIFICATE-----
MIIDtzCCAp+gAwIBAgIEet16RjANBgkqhkiG9w0BAQsFADB2MQswCQYDVQQGEwJVUzEUMBIGA1UE
CBMLVW5zcGVjaWZpZWQxFDASBgNVBAcTC1Vuc3BlY2lmaWVkMREwDwYDVQQKEwhTb25hdHlwZTEQ
MA4GA1UECxMHRXhhbXBsZTEWMBQGA1UEAwwNKi5lY29tcC1uZXh1czAeFw0xNjExMTQxMDE5NDJa
Fw0zMDA3MjQxMDE5NDJaMHYxCzAJBgNVBAYTAlVTMRQwEgYDVQQIEwtVbnNwZWNpZmllZDEUMBIG
A1UEBxMLVW5zcGVjaWZpZWQxETAPBgNVBAoTCFNvbmF0eXBlMRAwDgYDVQQLEwdFeGFtcGxlMRYw
FAYDVQQDDA0qLmVjb21wLW5leHVzMIIBIjANBgkqhkiG9w0BAQEFAAOCAQ8AMIIBCgKCAQEAqkDu
vC91cZxOaRMYGHSyDeuw4hyXjqyD5Etl5L5TNN7+uFKEtvXsRYOxtD62TqWHKozffLE5o6zoRZL4
8qNTQyAx0LaEfWfR2w0jat+UqtqEtW0xpOD0/O0qRq5Y/XG3Yr8SQ/y84Pr1FIflM7pM4PZTt3kc
UfqzbaONW5K8t+UG+5jgNXdRk3hln8WMunVZeci0J6TV+tWs9tOeAKBdpI7K7LV+FJBaF8vBAw2x
8AhlNPXKQUhK+M3DD73c1aLWrZ3mIwJXt2oQUDwgtXGCPR1/Z9f2tTAoDxpzvkwtP/BtH3qvgtpY
QfDNmWbJVHh6ll39Hapt7V0v4aCRSN21ZQIDAQABo00wSzAMBgNVHRMEBTADAQH/MBwGA1UdEQQV
MBOCC2Vjb21wLW5leHVzhwQK0MVLMB0GA1UdDgQWBBQxcUlk/lkKkwSz0GuewbXptJxl+zANBgkq
hkiG9w0BAQsFAAOCAQEAPnNbtdreMZaUSjv+1eqpriLKquwnZhnwWENn1u3sw4hTAWQc+ehhogGg
eIqPN81Dt3jhr0bYZW+r3gGq7tgrLxdSXso8bTtqHsFLszirgWcQXDlBQGnw9wqp/KBzeDJInJep
d6aGu3yBXV6459S/mClxZTSvsR+Vz3rRWxx01R3/ft5/myqrRMDnEncqPopTbEamBuUJL3eJDpFO
xlVqYR3y6AXwwguMaTiHMfFBmDOVaz4K8Qy6AaHH9eoch9fxOJ/7ASvqSwkC9GYTJSnF2vE37rmH
kPp//Vm4WSnQ2NrBGkH9rUUdYdDdgWJYnTeZ+YFd8J6z9xNiEn9QKQNNcA==
-----END CERTIFICATE-----

EOF_CONFIG
## Adding configuration file: vm-postgresql-console.properties
cat > /tmp/vm-postgresql-console.properties << EOF_CONFIG
localhost.endpoint=http://localhost:9999
localhost.user=console
localhost.password=MDBmMzE0NTgyMDU1NmVj
EOF_CONFIG

## Adding configuration file: vm-postgresql-gui.properties
cat > /tmp/vm-postgresql-gui.properties << EOF_CONFIG
EOF_CONFIG

## Adding configuration file: vm-postgresql-log4j.properties
cat > /tmp/vm-postgresql-log4j.properties << EOF_CONFIG
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

## Adding configuration file: vm-postgresql-manager.properties
cat > /tmp/vm-postgresql-manager.properties << EOF_CONFIG
server.dir = data/resources
metrics.dir = data/metrics
properties.dir = data/properties
server.port = 9999
server.user.console = MDBmMzE0NTgyMDU1NmVj
server.user.gui = M2NiOTg1YzNiYTI2NTJh
server.user.client = OTNmMmFkYzkxMzYzNTk0
EOF_CONFIG

## Adding configuration file: vm-postgresql-runtime.properties
cat > /tmp/vm-postgresql-runtime.properties << EOF_CONFIG
factory.vm=org.openecomp.dcae.controller.service.servers.vm.DcaeVmFactory
factory.postgres=org.openecomp.dcae.controller.service.storage.postgres.service.impl.ServicePackageImpl
EOF_CONFIG

## Adding configuration file: vm-postgresql-hosts
cat > /tmp/vm-postgresql-hosts << EOF_CONFIG
EOF_CONFIG

## Adding configuration file: monitoring-agent-gui.properties
cat > /tmp/monitoring-agent-gui.properties << EOF_CONFIG
EOF_CONFIG

cat >> /etc/hosts << HOSTS_EOF
HOSTS_EOF

cat > /tmp/certificate.pkcs12.b64code << EOF_CERT
EOF_CERT

##############################################################
##################### CLOUDINIT ##############################
##############################################################

## need to fix cloudinit in Centos.

CLOUDHOSTCFG=/etc/cloud/cloud.cfg.d/99_hostname.cfg
if [ -f /etc/redhat-release ]; then
   # CentOS/RHEL
   ( echo "hostname: \$(hostname)"; echo "fqdn: \$(hostname -f)" ) > \$CLOUDHOSTCFG
fi

mkdir -p ~/.ssh
touch ~/.ssh/authorized_keys

echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYz++VKcW3Sw0Sh7fFyTIjXED6NUUNYbje7awcnvaHHAC0rUxs7boX6hmWDViXoGZA5xw4Xhk5kIEs+zxMCDlF1q/9rbyq5ndonlBz3aPx7+SBqVR5sPalbSr8dJhGPwpj/0Df+FzqjGVL2p2d4VV7SeT/kKrNcSY6SmYHln6osoGFAHsOZC0d+fiba4zfCI9EI6zHdyCujwayjQ5W5UgA50XQ0KXpI5WtF6MOwO6jPL3SNNDlWobG/nsCAMxTQ04dALpYSoamM12Ps72MfxEwaKkoAcsH6WsFbuvoUSXwNcosmyxYrxNynsUz4C2Tz+PZqelGvm8Y8MtNuhN7oqAD root@ecomp-jumpbox >> /home/ubuntu/.ssh/authorized_keys

######### step-1

cp /tmp/ecomp-nexus.crt /usr/local/share/ca-certificates/ ; update-ca-certificates

######### step-2

echo 162.242.254.138 ecomp-nexus >> /etc/hosts

######### step-3

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

case runtime in
  %*)
    A1=org.openecomp.dcae.controller:dcae-controller-core-utils:1.0.0:zip
    ;;
  *)
    A1=org.openecomp.dcae.controller:dcae-controller-core-utils:1.0.0:zip:runtime
    ;;
esac

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-core-utils/1.0.0/dcae-controller-core-utils-1.0.0-runtime.zip -P /opt/app/dcae-controller-core-utils

case zip in
  jar)
    mkdir /opt/app/dcae-controller-core-utils/lib
    mv /opt/app/dcae-controller-core-utils/*.jar /opt/app/dcae-controller-core-utils/lib
    ;;
  zip)
    ( cd /opt/app/dcae-controller-core-utils ; unzip -o dcae-controller-core-utils*.zip )
    ;;
esac

chown -R dcae:dcae /opt/app/dcae-controller-core-utils

######### step-4

/opt/app/dcae-controller-core-utils/bin/fs-init.py

######### step-5

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

case runtime in
  %*)
    A1=org.openecomp.dcae.controller:dcae-controller-service-common-vm-manager:1.0.0:zip
    ;;
  *)
    A1=org.openecomp.dcae.controller:dcae-controller-service-common-vm-manager:1.0.0:zip:runtime
    ;;
esac

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-service-common-vm-manager/1.0.0/dcae-controller-service-common-vm-manager-1.0.0-runtime.zip -P /opt/app/dcae-controller-service-common-vm-manager

case zip in
  jar)
    mkdir /opt/app/dcae-controller-service-common-vm-manager/lib
    mv /opt/app/dcae-controller-service-common-vm-manager/*.jar /opt/app/dcae-controller-service-common-vm-manager/lib
    ;;
  zip)
    ( cd /opt/app/dcae-controller-service-common-vm-manager ; unzip -o dcae-controller-service-common-vm-manager*.zip )
    ;;
esac

chown -R dcae:dcae /opt/app/dcae-controller-service-common-vm-manager

######### step-6

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

case %{assemblyId} in
  %*)
    A1=org.openecomp.dcae.controller:dcae-controller-service-storage-postgres-model:1.0.0:jar
    ;;
  *)
    A1=org.openecomp.dcae.controller:dcae-controller-service-storage-postgres-model:1.0.0:jar:%{assemblyId}
    ;;
esac

wget https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-service-storage-postgres-model/1.0.0/dcae-controller-service-storage-postgres-model-1.0.0.jar -P /opt/app/dcae-controller-service-storage-postgres-model

case jar in
  jar)
    mkdir /opt/app/dcae-controller-service-storage-postgres-model/lib
    mv /opt/app/dcae-controller-service-storage-postgres-model/*.jar /opt/app/dcae-controller-service-storage-postgres-model/lib
    ;;
  zip)
    ( cd /opt/app/dcae-controller-service-storage-postgres-model ; unzip -o dcae-controller-service-storage-postgres-model*.zip )
    ;;
esac

chown -R dcae:dcae /opt/app/dcae-controller-service-storage-postgres-model

######### step-7

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

OUT=/tmp/`basename https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-cdf_1.0.0.deb`

case deb in
  deb)
    dpkg --install \$OUT
    ;;
  jar)
    mkdir -p /opt/app/%{artifactId}/lib
    mv \$OUT /opt/app/%{artifactId}/lib
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
  zip)
    mkdir -p /opt/app/%{artifactId}/lib
    ( cd /opt/app/%{artifactId} ; cp -p \$OUT . ; unzip -o \$OUT )
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
esac

######### step-8

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

OUT=/tmp/`basename https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-postgresql-prep_1.0.0.deb`

case deb in
  deb)
    dpkg --install \$OUT
    ;;
  jar)
    mkdir -p /opt/app/%{artifactId}/lib
    mv \$OUT /opt/app/%{artifactId}/lib
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
  zip)
    mkdir -p /opt/app/%{artifactId}/lib
    ( cd /opt/app/%{artifactId} ; cp -p \$OUT . ; unzip -o \$OUT )
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
esac

######### step-9

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

OUT=/tmp/`basename https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-postgresql-config_1.0.0.deb`

case deb in
  deb)
    dpkg --install \$OUT
    ;;
  jar)
    mkdir -p /opt/app/%{artifactId}/lib
    mv \$OUT /opt/app/%{artifactId}/lib
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
  zip)
    mkdir -p /opt/app/%{artifactId}/lib
    ( cd /opt/app/%{artifactId} ; cp -p \$OUT . ; unzip -o \$OUT )
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
esac

######### step-10

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

OUT=/tmp/`basename https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-pgaas_1.0.0.deb`

case deb in
  deb)
    dpkg --install \$OUT
    ;;
  jar)
    mkdir -p /opt/app/%{artifactId}/lib
    mv \$OUT /opt/app/%{artifactId}/lib
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
  zip)
    mkdir -p /opt/app/%{artifactId}/lib
    ( cd /opt/app/%{artifactId} ; cp -p \$OUT . ; unzip -o \$OUT )
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
esac

touch /etc/sudoers.d/dcae-postgres
echo "dcae ALL=(postgres) NOPASSWD: ALL" > /etc/sudoers.d/dcae-postgres

/opt/app/postgresql-prep/bin/iDNS-responder.py &

/etc/init.d/cron restart

######### step-11

if [ ! -e /home/dcae ]; then useradd -m -s /bin/bash dcae; fi

OUT=/tmp/`basename https://nexus.onap.org/content/sites/raw/org.openecomp.dcae.pgaas/deb-releases/org.openecomp.dcae.storage.pgaas-pgaas-post_1.0.0.deb`
case deb in
  deb)
    dpkg --install \$OUT
    ;;
  jar)
    mkdir -p /opt/app/%{artifactId}/lib
    mv \$OUT /opt/app/%{artifactId}/lib
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
  zip)
    mkdir -p /opt/app/%{artifactId}/lib
    ( cd /opt/app/%{artifactId} ; cp -p \$OUT . ; unzip -o \$OUT )
    chown -R dcae:dcae /opt/app/%{artifactId}
    ;;
esac

######### step-12

find /opt -type f -exec sed -i 's/sudo//g' {} \;
su dcae -c "/opt/app/dcae-controller-service-common-vm-manager/bin/manager.sh config"
su dcae -c "/opt/app/dcae-controller-service-common-vm-manager/bin/manager.sh restart"

mkdir /home/dcae/.ssh
chmod og-rwx /home/dcae/.ssh
chown -R dcae:dcae /home/dcae/.ssh
touch /home/dcae/.ssh/authorized_keys
chmod og-rwx /home/dcae/.ssh/authorized_keys
chown -R dcae:dcae /home/dcae/.ssh/authorized_keys
echo ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCYz++VKcW3Sw0Sh7fFyTIjXED6NUUNYbje7awcnvaHHAC0rUxs7boX6hmWDViXoGZA5xw4Xhk5kIEs+zxMCDlF1q/9rbyq5ndonlBz3aPx7+SBqVR5sPalbSr8dJhGPwpj/0Df+FzqjGVL2p2d4VV7SeT/kKrNcSY6SmYHln6osoGFAHsOZC0d+fiba4zfCI9EI6zHdyCujwayjQ5W5UgA50XQ0KXpI5WtF6MOwO6jPL3SNNDlWobG/nsCAMxTQ04dALpYSoamM12Ps72MfxEwaKkoAcsH6WsFbuvoUSXwNcosmyxYrxNynsUz4C2Tz+PZqelGvm8Y8MtNuhN7oqAD root@ecomp-jumpbox >> /home/dcae/.ssh/authorized_keys
#no final script: vm-postgresql.userdata
EOF_DCAE_INSTALL
echo null > /tmp/.password
chmod u+x /tmp/dcae_install.sh
/tmp/dcae_install.sh 2>&1 | tee /tmp/dcae_install.log
