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
DOCKER_VERSION="$9"
GERRIT_BRANCH="$10"
CLOUD_ENV="$11"
EXETERNAL_DNS="$12"
POLICY_REPO="$13"

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
echo $DOCKER_VERSION                            > /opt/config/docker_version.txt
echo $GERRIT_BRANCH                             > /opt/config/gerrit_branch.txt
echo $CLOUD_ENV                                 > /opt/config/cloud_env.txt
echo $EXETERNAL_DNS                             > /opt/config/external_dns.txt
echo $POLICY_REPO                               > /opt/config/remote_repo.txt
touch /opt/policy_install.sh
chmod 777 /opt/policy_install.sh
curl -k $NEXUS_REPO/org.onap.demo/boot/$ARTIFACTS_VERSION/policy_install.sh -o /opt/policy_install.sh;
apt-get update
apt-get install -y docker.io
cd /opt
chmod +x policy_install.sh
/opt/policy_install.sh > policy_install.log 2>&1