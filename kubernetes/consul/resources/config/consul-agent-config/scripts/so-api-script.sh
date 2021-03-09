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

## Query the health check API.
HEALTH_CHECK_ENDPOINT="http://so:8080/ecomp/mso/infra/healthcheck"
HEALTH_CHECK_RESPONSE=$(curl -s $HEALTH_CHECK_ENDPOINT)

READY=$(echo $HEALTH_CHECK_RESPONSE | grep "Application ready")

if [ -n $READY ]; then
  echo "Query against health check endpoint: $HEALTH_CHECK_ENDPOINT"
  echo "Produces response: $HEALTH_CHECK_RESPONSE"
  echo "Application is not in an available state"
  return 2
else
  echo "Application is available."
  return 0
fi
