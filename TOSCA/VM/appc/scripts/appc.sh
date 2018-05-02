#!/bin/sh

# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2017 AT&T
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#============LICENSE_END============================================

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
DMAAP_TOPIC="$12"
OPENSTACK_USERNAME="$13"
TENANT_ID="$14"
OPENSTACK_API_KEY="$15"
OPENSTACK_REGION="$16"
KEYSTONE="$17"
APPC_REPO="$18"
DOCKER_VERSION="$19"
DGBUILDER_DOCKER="$20"

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
echo $DMAAP_TOPIC                               > /opt/config/dmaap_topic.txt
echo $ARTIFACTS_VERSION                         > /opt/config/artifacts_version.txt
echo $DNS_IP                                    > /opt/config/dns_ip_addr.txt
echo $DOCKER_VERSION                            > /opt/config/docker_version.txt
echo $GERRIT_BRANCH                             > /opt/config/gerrit_branch.txt
echo $DGBUILDER_DOCKER							> /opt/config/dgbuilder_version.txt
echo $CLOUD_ENV                                 > /opt/config/cloud_env.txt
echo $EXETERNAL_DNS                             > /opt/config/external_dns.txt
echo $APPC_REPO                                 > /opt/config/remote_repo.txt
echo $OPENSTACK_USERNAME                        > /opt/config/openstack_username.txt
echo $TENANT_ID                                 > /opt/config/tenant_id.txt
echo $OPENSTACK_API_KEY                         > /opt/config/openstack_api_key.txt
echo $OPENSTACK_REGION                          > /opt/config/openstack_region.txt
echo $KEYSTONE                                  > /opt/config/keystone.txt

touch /opt/appc_install.sh
chmod 777 /opt/appc_install.sh
curl -k $NEXUS_REPO/org.onap.demo/boot/$ARTIFACTS_VERSION/appc_install.sh -o /opt/appc_install.sh
cd /opt
chmod +x appc_install.sh
/opt/appc_install.sh > appc_install.log 2>&1