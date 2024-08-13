#!/bin/sh

{{/*
# Copyright © 2017 Amdocs, Bell Canada
# Modifications Copyright © 2018 AT&T,VMware
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

{{/*
# Controller is a process that reads from Music Q
# It uses no ports (TCP or HTTP). The PROB will check
# if the controller process exists or not. In case
# it exists, it will send 0, else send 1 so k8s can i
# restart the container
*/}}

pid="$(pgrep -f '/usr/local/bin/conductor')"
if [ -z "$pid" ]
then
   echo 1
else
   echo 0
fi
