#!/bin/sh

###
# ============LICENSE_START=======================================================
# ONAP : SDN-C
# ================================================================================
# Copyright (C) 2023 highstreet technologies  Intellectual Property. All rights reserved.
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
# ============LICENSE_END=========================================================
###

echo "Create '${SDNRDBDATABASE}' and user '${SDNRDBUSERNAME}' within maria-galera database cluster"
root_user=root
mysql -v -v -u $root_user -p${MYSQL_ROOT_PASSWORD} -Bse "\
CREATE DATABASE IF NOT EXISTS ${SDNRDBDATABASE}; \
CREATE USER IF NOT EXISTS ${SDNRDBUSERNAME}@'%' IDENTIFIED BY '${SDNRDBPASSWORD}'; \
GRANT ALL PRIVILEGES ON ${SDNRDBDATABASE}.* TO '${SDNRDBUSERNAME}'@'%'; \
FLUSH PRIVILEGES; "

