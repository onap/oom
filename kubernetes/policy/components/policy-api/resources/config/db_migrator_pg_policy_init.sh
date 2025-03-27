#!/bin/sh
{{/*
# Copyright (C) 2022, 2024 Nordix Foundation.
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

for schema in ${SQL_DB}; do
    echo "Initializing $schema..."
    /opt/app/policy/bin/prepare_upgrade.sh ${schema}

    /opt/app/policy/bin/db-migrator-pg -s ${schema} -o report

    /opt/app/policy/bin/db-migrator-pg -s ${schema} -o upgrade
    rc=$?

    /opt/app/policy/bin/db-migrator-pg -s ${schema} -o report

    if [ "$rc" != 0 ]; then
        break
    fi
done
