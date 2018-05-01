# Copyright © 2017 Amdocs, Bell Canada
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

OUT=$(curl -o /dev/null -s -w "%{http_code}\n"  \
  http://localhost:8080/MUSIC/rest/v2/admin/onboardAppWithMusic \
  -H 'Cache-Control: no-cache' \
  -H 'Content-Type: application/json' \
  -H 'Postman-Token: 705d4a9d-aaf2-40b4-914a-e0ce1a79534c' \
  -d '{
   "appname": "conductor",
   "userId" : "conductor",
   "isAAF"  : false,
   "password" : "c0nduct0r"
}
')

if [ ${OUT} = "200" ]; then
    echo "Success"
    echo 1 > /tmp/onboarded
    exit 0;
else
    echo "Failure"
    exit 1;
fi
