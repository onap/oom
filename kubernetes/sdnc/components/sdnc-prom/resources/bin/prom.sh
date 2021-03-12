#!/bin/sh

{{/*
# Copyright © 2018 Amdocs
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

if [ "${SDNC_IS_PRIMARY_CLUSTER:-true}" = "true" ];then
  id=sdnc01
else
  id=sdnc02
fi

# should PROM start as passive?
state=$( bin/sdnc.cluster )
if [ "$state" = "standby" ]; then
  echo "Starting PROM in passive mode"
  passive="-p"
fi

# start PROM as foreground process
java -jar prom.jar --id $id $passive --config config
