#!/bin/bash
#############################################################################
#
# Copyright © 2018 Amdocs.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
#############################################################################
#
# This installation is for a rancher managed install of kubernetes
# after this run the standard oom install
# this installation can be run on amy ubuntu 16.04 VM or physical host
# https://wiki.onap.org/display/DW/ONAP+on+Kubernetes
# source from https://jira.onap.org/browse/OOM-715
# Michael O'Brien
# Amsterdam
#     Rancher 1.6.10, Kubernetes 1.7.7, Kubectl 1.7.7, Helm 2.3.0, Docker 1.12
# master
#     Rancher 1.6.14, Kubernetes 1.8.10, Kubectl 1.8.10, Helm 2.7.2, Docker 17.03
# run as root - because of the logout that would be required after the docker user set
usage() {
cat <<EOF
Usage: $0 [PARAMs]
-u                  : Display usage
-b [branch]         : branch = master or amsterdam (required)
-s [server]         : server = IP or DNS name (required)
-e [environment]    : use the default (onap)
-r [resourcegroup]  : ARM resource group name
-t [template]       : ARM template file
-p [parameters]     : ARM parameters file
EOF
}

install_onap() {
  az group delete --name $RESOURCE_GROUP -y
  az group create --name $RESOURCE_GROUP --location eastus
  az group deployment create --resource-group $RESOURCE_GROUP --template-file $TEMPLATE --parameters @$PARAMETERS 
}


BRANCH=
SERVER=
ENVIRON=
RESOURCE_GROUP=
TEMPLATE=
PARAMETERS=
while getopts ":b:s:e:r:t:p:u:" PARAM; do
  case $PARAM in
    u)
      usage
      exit 1
      ;;
    b)
      BRANCH=${OPTARG}
      ;;
    e)
      ENVIRON=${OPTARG}
      ;;
    s)
      SERVER=${OPTARG}
      ;;
    r)
      RESOURCE_GROUP=${OPTARG}
      ;;
    t)
      TEMPLATE=${OPTARG}
      ;;
    p)
      PARAMETERS=${OPTARG}
      ;;
    ?)
      usage
      exit
      ;;
    esac
done

if [[ -z $BRANCH ]]; then
  usage
  exit 1
fi

install_onap $RESOURCE_GROUP $TEMPLATE $BRANCH $SERVER $ENVIRON
