# Copyright © 2018 Amdocs, AT&T, Bell Canada
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

# sourced, not executed, by docker-entrypoint.sh (/bin/bash)

# defaults
: ${ICE_CMS_DB_USER:="icecmsuser"}
: ${ICE_CMS_DB_NAME:="icecmsdb"}
: ${ICE_CMS_DB_PASSWORD:="na"}

psql -v ON_ERROR_STOP=1 --username "$POSTGRES_USER" --dbname "$POSTGRES_DB" <<- EOF
    CREATE USER ${ICE_CMS_DB_USER} WITH CREATEDB PASSWORD '${ICE_CMS_DB_PASSWORD}';
    CREATE DATABASE ${ICE_CMS_DB_NAME} WITH OWNER ${ICE_CMS_DB_USER} ENCODING 'utf-8';
EOF
