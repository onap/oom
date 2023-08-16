#!/bin/sh
{{/*
# Copyright © 2017 Amdocs, Bell Canada, AT&T
# Modifications Copyright © 2018, 2020 AT&T Intellectual Property
# Modifications Copyright (C) 2021 Nordix Foundation.
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

mysqlcmd() { mysql  -h ${MYSQL_HOST} -P ${MYSQL_PORT} "$@"; };

for db in migration pooling policyadmin policyclamp operationshistory clampacm
do
    mysqlcmd -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "CREATE DATABASE IF NOT EXISTS ${db};"
    mysqlcmd -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "GRANT ALL PRIVILEGES ON \`${db}\`.* TO '${MYSQL_USER}'@'%' ;"
done

mysqlcmd -uroot -p"${MYSQL_ROOT_PASSWORD}" --execute "FLUSH PRIVILEGES;"
