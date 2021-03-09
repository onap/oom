#!/bin/sh

{{/*
# Copyright © 2018  AT&T, Amdocs, Bell Canada Intellectual Property.  All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

APPC_DBHOST_POD=$(/consul/bin/kubectl -n {{ include "common.namespace" . }}  get pod | grep -o "appc-dbhost-[^[:space:]]*")
if [ -n "$APPC_DBHOST_POD" ]; then
   if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $APPC_DBHOST_POD -- ./healthcheck.sh |grep -i "mysqld is alive"; then
      echo Success. APPC DBHost is running. 2>&1
      exit 0
   else
      echo Failed. APPC DBHost is not running. 2>&1
      exit 1
   fi
else
   echo Failed. APPC DBHost is offline. 2>&1
   exit 1
fi
