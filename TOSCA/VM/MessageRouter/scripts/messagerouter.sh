#!/bin/sh

#
PUBIP="$1"
PVTIP="$2"
NEXUS_REPO="$3"
DOCKER_REPO="$4"
NEXUS_USERNAME="$5"
NEXUS_PASSWORD="$6"
ARTIFACTS_VERSION="$7"
DNS_IP="$8"
GERRIT_BRANCH="$9"
CLOUD_ENV="$10"
EXETERNAL_DNS="$11"
MR_REPO="$12"

export HOSTNAME=`hostname`
echo 127.0.1.1 $HOSTNAME >>/etc/hosts
echo $PVTIP $HOSTNAME >>/etc/hosts
echo $PUBIP $HOSTNAME >>/etc/hosts


mkdir /opt/config
chmod 777 /opt/config
echo $PUBIP                                     > /opt/config/public_ip.txt
echo $NEXUS_REPO                                > /opt/config/nexus_repo.txt
echo $DOCKER_REPO                               > /opt/config/nexus_docker_repo.txt
echo $NEXUS_USERNAME                            > /opt/config/nexus_username.txt
echo $NEXUS_PASSWORD                            > /opt/config/nexus_password.txt
echo $ARTIFACTS_VERSION                         > /opt/config/artifacts_version.txt
echo $DNS_IP                                    > /opt/config/dns_ip_addr.txt
echo $GERRIT_BRANCH                             > /opt/config/gerrit_branch.txt
echo $CLOUD_ENV                                 > /opt/config/cloud_env.txt
echo $EXETERNAL_DNS                             > /opt/config/external_dns.txt
echo $MR_REPO                                   > /opt/config/remote_repo.txt

touch /opt/mr_install.sh
chmod 777 /opt/mr_install.sh
curl -k $NEXUS_REPO/org.onap.demo/boot/$ARTIFACTS_VERSION/mr_install.sh -o /opt/mr_install.sh;
cd /opt
chmod +x mr_install.sh
/opt/mr_install.sh > mr_install.log 2>&1