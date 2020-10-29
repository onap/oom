#!/bin/sh
{{/*
#
# ============LICENSE_START==========================================
# ===================================================================
# Copyright © 2017 AT&T Intellectual Property. All rights reserved.
# ===================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#        http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END============================================
#
# ECOMP and OpenECOMP are trademarks
# and service marks of AT&T Intellectual Property.
#
*/}}

echo "Creating catalogdb database . . ." 1>/tmp/mariadb-catalogdb.log 2>&1

mysql -uroot -p$MYSQL_ROOT_PASSWORD << EOF || exit 1
DROP DATABASE IF EXISTS catalogdb;
CREATE DATABASE /*!32312 IF NOT EXISTS*/ catalogdb /*!40100 DEFAULT CHARACTER SET latin1 */;
DROP USER IF EXISTS '${CATALOG_DB_USER}';
CREATE USER '${CATALOG_DB_USER}';
GRANT ALL on catalogdb.* to '${CATALOG_DB_USER}' identified by '${CATALOG_DB_PASSWORD}' with GRANT OPTION;
FLUSH PRIVILEGES;
EOF

echo "Created catalogdb database . . ." 1>>/tmp/mariadb-catalogdb.log 2>&1
