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
    echo "Usage: $(basename $0)"
    echo
}

if [[ ${DEBUG} == y ]]; then
    set -x
fi

if [[ -z ${BUILD_VERSION} ]]; then
    echo "no BUILD_VERSION available as environment variable""
    usage
    exit 1
fi

if [[ -z ${POLICY_INSTALL} ]]; then
    echo "no POLICY_INSTALL available as environment variable""
    usage
    exit 2
fi

CONFIG_DIR=$(dirname "$0")
echo "invoking ${CONFIG_DIR}/apps-install.sh for controlloop ${BUILD_VERSION} at ${POLICY_INSTALL}"
export DEBUG=y
bash ${CONFIG_DIR}/apps-install.sh controlloop ${BUILD_VERSION} ${POLICY_INSTALL}
unzip -o ${POLICY_INSTALL}/app*.zip -d ${POLICY_INSTALL}
