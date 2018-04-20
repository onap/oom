#!/bin/bash
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

printf "%s" "$*"
printf `pwd`
printf "%s" "---------------"

kubectl create namespace $1
kubectl create clusterrolebinding $1-admin-binding --clusterrole=cluster-admin --serviceaccount=$1:default
kubectl --namespace $1 create secret docker-registry $1-docker-registry-key --docker-server=nexus3.onap.org:10001 --docker-username=docker --docker-password=docker --docker-email=@