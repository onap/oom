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

NAME=$(/consul/bin/kubectl -n {{ include "common.namespace" . }} get pod | grep -o "[^[:space:]]*-clampdb[^[:space:]]*")

   if [ -n "$NAME" ]; then
       if /consul/bin/kubectl -n {{ include "common.namespace" . }} exec -it $NAME -- bash -c 'mysqladmin status -u root -p$MYSQL_ROOT_PASSWORD' > /dev/null; then
         echo Success. CLAMP DBHost is running. 2>&1
         exit 0
      else
         echo Failed. CLAMP DBHost is not running. 2>&1
         exit 1
      fi
   else
      echo Failed. CLAMP DBHost is offline. 2>&1
      exit 1
   fi

