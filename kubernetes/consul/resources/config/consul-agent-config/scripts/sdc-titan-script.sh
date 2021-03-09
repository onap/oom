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
HEALTH_CHECK_ENDPOINT="http://sdc-fe:8181/sdc1/rest/healthCheck"
HEALTH_CHECK_RESPONSE=$(curl -s $HEALTH_CHECK_ENDPOINT)

## Strip out the ON_BOARDING section from the response XML (otherwise we will
## get duplicate results when we search for component TITAN) and check to see if
## the TITAN component is reported as up.
READY=$(echo "$HEALTH_CHECK_RESPONSE" | sed '/ON_BOARDING/,/]/d' | grep -A 1 "TITAN" | grep "UP")

if [ -n $READY ]; then
  echo "Query against health check endpoint: $HEALTH_CHECK_ENDPOINT"
  echo "Produces response: $HEALTH_CHECK_RESPONSE"
  echo "Application is not in an available state"
  return 2
else
  echo "Application is available."
  return 0
fi
