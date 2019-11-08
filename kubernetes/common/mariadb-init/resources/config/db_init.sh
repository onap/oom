#!/bin/sh
# Copyright © 2019 Orange
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

echo "Creating database {{ .Values.config.mysqlDatabase }} and user {{ .Values.config.userName }}..."

mysql -h ${DB_HOST} -P ${DB_PORT} -uroot -p$MYSQL_ROOT_PASSWORD << 'EOF' || exit 1
CREATE OR REPLACE USER '{{ .Values.config.userName }}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE OR REPLACE USER '{{ .Values.config.userName }}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD}';
CREATE DATABASE IF NOT EXISTS {{ .Values.config.mysqlDatabase }};
GRANT ALL PRIVILEGES ON {{ .Values.config.mysqlDatabase }}.* TO '{{ .Values.config.userName }}'@'%';
GRANT ALL PRIVILEGES ON {{ .Values.config.mysqlDatabase }}.* TO '{{ .Values.config.userName }}'@'localhost';
EOF

echo "Created database {{ .Values.config.mysqlDatabase }} and user {{ .Values.config.userName }}."

{{ range $db, $dbInfos := .Values.config.mysqlAdditionalDatabases -}}
echo "Creating database {{ $db }} and user {{ $dbInfos.user }}..."

mysql -h ${DB_HOST} -P ${DB_PORT} -uroot -p$MYSQL_ROOT_PASSWORD << 'EOF' || exit 1
CREATE OR REPLACE USER '{{ $dbInfos.user }}'@'localhost' IDENTIFIED BY '${MYSQL_PASSWORD_{{ $db | upper }}}';
CREATE OR REPLACE USER '{{ $dbInfos.user }}'@'%' IDENTIFIED BY '${MYSQL_PASSWORD_{{ $db | upper }}}';
CREATE DATABASE IF NOT EXISTS {{ $db }};
GRANT ALL PRIVILEGES ON {{ $db }}.* TO '{{ $dbInfos.user }}'@'%';
GRANT ALL PRIVILEGES ON {{ $db }}.* TO '{{ $dbInfos.user }}'@'localhost';
EOF

echo "Created database {{ $db }} and user {{ $dbInfos.user }}."
{{ end }}
