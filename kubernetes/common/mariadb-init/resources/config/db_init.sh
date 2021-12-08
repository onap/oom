#!/bin/sh

{{/*
# Copyright © 2019 Orange
# Copyright © 2020 Samsung Electronics
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

# make sure the script fails if any of commands failed
set -e

while read DB ; do
    USER_VAR="MYSQL_USER_$(echo $DB | tr '[:lower:]' '[:upper:]')"
    PASS_VAR="MYSQL_PASSWORD_$(echo $DB | tr '[:lower:]' '[:upper:]')"
{{/*
    # USER=${!USER_VAR}
    # PASS=`echo -n ${!PASS_VAR} | sed -e "s/'/''/g"`
    # eval replacement of the bashism equivalents above might present a security issue here
    # since it reads content from DB values filled by helm at the end of the script.
    # These possible values has to be constrainted and/or limited by helm for a safe use of eval.
*/}}
    eval USER=\$$USER_VAR
    PASS=$(eval echo -n \$$PASS_VAR | sed -e "s/'/''/g")
    MYSQL_OPTS=" -h "${DB_HOST}" -P "${DB_PORT}" -uroot -p"${MYSQL_ROOT_PASSWORD}

    echo "Creating database ${DB} and user ${USER}..."

    mysql $MYSQL_OPTS -e "CREATE OR REPLACE USER '${USER}'@'%' IDENTIFIED BY '${PASS}'"
    mysql $MYSQL_OPTS -e "CREATE DATABASE IF NOT EXISTS ${DB}"
    mysql $MYSQL_OPTS -e "GRANT ALL PRIVILEGES ON ${DB}.* TO '${USER}'@'%'"

    echo "Created database ${DB} and user ${USER}."
done <<EOF
{{ .Values.config.mysqlDatabase }}
{{- range $db, $_value := .Values.config.mysqlAdditionalDatabases }}
{{ $db }}
{{- end }}
EOF
