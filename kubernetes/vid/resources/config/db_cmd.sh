#!/bin/sh
# Copyright © 2018 AT&T
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

echo "Going to run mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -P${MYSQL_PORT} ..."
mysql -u${MYSQL_USER} -p${MYSQL_PASSWORD} -h${MYSQL_HOST} -P${MYSQL_PORT} < /db-config/vid-pre-init.sql
if [ $? -ne 0 ];then
        echo "ERROR: Failed to run ${cmd} vid-pre-init.sql"
        exit 1
else
        echo "INFO: Database initialized successfully"
fi
