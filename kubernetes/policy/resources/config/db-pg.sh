#!/bin/sh
#
# ============LICENSE_START=======================================================
# Copyright (C) 2021-2022 Nordix Foundation.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#    http://www.apache.org/licenses/LICENSE-2.0
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# SPDX-License-Identifier: Apache-2.0
# ============LICENSE_END=========================================================
#

#psql() { /usr/bin/psql  -h ${PG_HOST} -p ${PG_PORT} "$@"; };

export PGPASSWORD=${PG_ADMIN_PASSWORD};

psql -h ${PG_HOST} -p ${PG_PORT} -U postgres --command "CREATE USER ${PG_USER} WITH PASSWORD '${PG_USER_PASSWORD}'"

for db in migration pooling policyadmin policyclamp operationshistory clampacm
do
    psql -h ${PG_HOST} -p ${PG_PORT} -U postgres --command "CREATE DATABASE ${db};"
    psql -h ${PG_HOST} -p ${PG_PORT} -U postgres --command "GRANT ALL PRIVILEGES ON DATABASE ${db} TO ${PG_USER};"
done
