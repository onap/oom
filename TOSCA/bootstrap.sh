#!/bin/sh

# ============LICENSE_START==========================================
# ===================================================================
# Copyright (c) 2018 AT&T
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

# this script will init a community version Cloudify manager
# 1.environment ubuntu 16.04
# 2. git clone oom project into that ubuntu environment
# 3. provide the Openstack information in /TOSCA/cloudify-environment-setup/input/openstack.yaml
# 4. execute this script with sudo


apt-get update
apt-get install build-essential libssl-dev libffi-dev python-dev gcc -y
wget http://repository.cloudifysource.org/cloudify/18.3.23/community-release/cloudify-cli-community-18.3.23.deb
dpkg -i cloudify-cli-community-18.3.23.deb
cfy install cloudify-environment-setup/openstack.yaml -i cloudify-environment-setup/inputs/openstack.yaml --install-plugins --task-retries=30 --task-retry-interval=5
cfy install cloudify-environment-setup/openstack.yaml -i cloudify-environment-setup/inputs/openstack.yaml --install-plugins --task-retries=30 --task-retry-interval=5 | tee cminstall.log
setprofiles=$(grep "cfy profiles use" cminstall.log | cut -d'`' -f2)
eval $setprofiles
cfy blueprints upload ONAP_TOSCA/onap_tosca.yaml -b onap
