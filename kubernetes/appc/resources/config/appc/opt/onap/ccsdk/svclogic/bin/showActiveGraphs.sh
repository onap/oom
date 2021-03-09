#!/bin/sh

{{/*
###
# ============LICENSE_START=======================================================
# openECOMP : SDN-C
# ================================================================================
# Copyright (C) 2017 AT&T Intellectual Property. All rights
#                                                       reserved.
# Modifications Copyright © 2018 Amdocs,Bell Canada
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
*/}}

MYSQL_USER=${SDNC_DB_USER}
MYSQL_PWD=${SDNC_DB_PASSWD}
MYSQL_DB={{.Values.config.sdncdb.dbName}}
MYSQL_HOST=${MYSQL_HOST:-{{.Values.config.mariadbGaleraSVCName}}.{{.Release.Namespace}}}

mysql --user=${MYSQL_USER} --password=${MYSQL_PWD} --host=${MYSQL_HOST} ${MYSQL_DB} <<-END
SELECT module, rpc, version, mode from SVC_LOGIC where active='Y';
END
