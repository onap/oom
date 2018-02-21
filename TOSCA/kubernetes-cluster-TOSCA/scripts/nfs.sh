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

# this script will set the NFS server on k8s master.

mkdir -p /dockerdata-nfs
chmod 777 /dockerdata-nfs
yum -y install nfs-utils
systemctl enable nfs-server.service
systemctl start nfs-server.service
echo "/dockerdata-nfs *(rw,no_root_squash,no_subtree_check)" |sudo tee --append /etc/exports
echo "/home/centos/dockerdata-nfs /dockerdata-nfs    none    bind  0  0" |sudo tee --append /etc/fstab
exportfs -a