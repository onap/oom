#!/bin/sh

{{/*
# Copyright © 2021 Orange
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
*/ -}}

echo "*** retrieving passwords for certificates"
export $(/opt/app/aaf_config/bin/agent.sh local showpass \
  {{.Values.fqi}} {{ .Values.fqdn }} | grep '^c' | xargs -0)
if [ -z "${{ .Values.envVarToCheck }}" ]
then
  echo " /!\ certificates retrieval failed"
  exit 1
fi
echo "*** password retrieval succeeded"
