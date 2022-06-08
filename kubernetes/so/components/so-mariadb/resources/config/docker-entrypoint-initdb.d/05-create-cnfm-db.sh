#!/bin/sh
{{/*
# ============LICENSE_START=======================================================
#  Copyright (C) 2023 Nordix Foundation.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================
*/}}

echo "Creating cnfm database . . ." 1>/tmp/mariadb-cnfmdb.log 2>&1

prepare_password()
{
    echo "$1" | sed -e "s/'/\\\\'/g; s/\"/\\\\\"/g"
}

CNFM_DB_PASSWORD=`prepare_password $CNFM_DB_PASSWORD`

mysql -uroot -p$MYSQL_ROOT_PASSWORD << EOF || exit 1
CREATE DATABASE /*!32312 IF NOT EXISTS*/ cnfm /*!40100 DEFAULT CHARACTER SET latin1 */;
DROP USER IF EXISTS '${CNFM_DB_USER}';
CREATE USER '${CNFM_DB_USER}';
GRANT ALL on cnfm.* to '${CNFM_DB_USER}' identified by '${CNFM_DB_PASSWORD}' with GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "Created cnfm database . . ." 1>>/tmp/mariadb-cnfmdb.log 2>&1