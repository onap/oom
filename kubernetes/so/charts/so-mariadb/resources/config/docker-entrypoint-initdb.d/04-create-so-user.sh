#!/bin/sh
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

echo "Creating so user . . ." 1>/tmp/mariadb-so-user.log 2>&1

mysql -uroot -p$MYSQL_ROOT_PASSWORD << 'EOF' || exit 1
DROP USER IF EXISTS 'so_user';
CREATE USER 'so_user';
GRANT USAGE ON *.* TO 'so_user'@'%' IDENTIFIED BY 'so_User123';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW ON `requestdb`.* TO 'so_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW ON `catalogdb`.* TO 'so_user'@'%';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE, SHOW VIEW ON `camundabpmn`.* TO 'so_user'@'%';
FLUSH PRIVILEGES;
EOF

echo "Created so user . . ." 1>>/tmp/mariadb-so-user.log 2>&1
