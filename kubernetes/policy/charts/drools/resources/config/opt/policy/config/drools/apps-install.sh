#!/bin/bash
#
# ============LICENSE_START=======================================================
# ONAP
# ================================================================================
# Copyright (C) 2018 AT&T Intellectual Property. All rights reserved.
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
#

# #################################
# Usage
# #################################

function usage {
    echo
    echo "Usage: $(basename $0) <application-name> <zipped-application-version> <download-directory>"
    echo "Example: $(basename $0) controlloop 1.2.0 /opt/policy/config/drools"
    echo
}

# #################################
# snapshot url computation
# #################################

function url_snapshot {
    if [[ $DEBUG == y ]]; then
        echo "-- ${FUNCNAME[0]} --"
        set -x
    fi

    APP_URL="${APP_URL}/snapshots/org/onap/policy/drools-applications/${APP_NAME}/packages/apps-${APP_NAME}/${APP_VERSION}"

    local APP_METADATA_URL="${APP_URL}/maven-metadata.xml"
    local APP_SNAPSHOT_VERSION=$(curl --silent "${APP_METADATA_URL}" | grep -Po "(?<=<value>).*(?=</value>)" | sort -V | tail -1)

    if [[ -z ${APP_SNAPSHOT_VERSION} ]]; then
        echo "ERROR: cannot compute SNAPSHOT version"
        usage
        exit 1
    fi

    APP_URL="${APP_URL}/apps-${APP_NAME}-${APP_SNAPSHOT_VERSION}.zip"
}

# #################################
# release url computation
# #################################

function url_release {
    if [[ $DEBUG == y ]]; then
        echo "-- ${FUNCNAME[0]} --"
        set -x
    fi

    APP_URL="${APP_URL}/releases/org/onap/policy/drools-applications/${APP_NAME}/packages/apps-${APP_NAME}/${APP_VERSION}/apps-${APP_NAME}-${APP_VERSION}.zip"
}

# #################################
# Main
# #################################

if [[ $DEBUG == y ]]; then
    set -x
fi

APP_NAME=$1
if [[ -z ${APP_NAME} ]]; then
    echo "ERROR: no APPLICATION NAME provided (ie. controlloop)"
    usage
    exit 1
fi

APP_VERSION=$2
if [[ -z ${APP_VERSION} ]]; then
    echo "ERROR: no APPLICATION VERSION provided"
    usage
    exit 1
fi

DOWNLOAD_DIR=$3
if [[ -z ${DOWNLOAD_DIR} ]]; then
    echo "ERROR: no DOWNLOAD DIRECTORY provided"
    usage
    exit 1
fi

if [[ ! -d ${DOWNLOAD_DIR} ]]; then
    echo "ERROR: ${DOWNLOAD_DIR} is not a directory"
    usage
    exit 1
fi

APP_GROUP_ID="org.onap.policy.drools-applications.${APP_NAME}.packages"
APP_ARTIFACT_ID="apps-${APP_NAME}"
APP_BASE_URL="https://nexus.onap.org/content/repositories"

APP_URL="${APP_BASE_URL}"

if [[ ${APP_VERSION} =~ \-SNAPSHOT$ ]]; then
    url_snapshot
else
    url_release
fi

wget "${APP_URL}" -O "${DOWNLOAD_DIR}"/apps-"${APP_NAME}".zip
if [[ $? != 0 ]]; then
    echo "ERROR: cannot download ${DOWNLOAD_DIR}/apps-${APP_NAME}.zip"
    exit 1
fi

echo "APP ${APP_NAME} stored at ${DOWNLOAD_DIR}/apps-${APP_NAME}.zip"
ls -l "${DOWNLOAD_DIR}"/apps-"${APP_NAME}".zip
