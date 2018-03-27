<<<<<<< b6f89dc0d2b461a7e3f083ebe8936de2bb8e0f6e:kubernetes/policy/charts/brmsgw/resources/config/pe/brmsgw-tweaks.sh
# Copyright © 2017 Amdocs, Bell Canada, AT&T
=======
# Copyright © 2017 Amdocs, Bell Canada
>>>>>>> Apache 2 license addition for all configuration:kubernetes/policy/resources/config/opt/policy/config/pe/brmsgw-tweaks.sh
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

#! /bin/bash

PROPS_BUILD="${POLICY_HOME}/etc/build.info"

PROPS_RUNTIME="${POLICY_HOME}/servers/brmsgw/config.properties"
PROPS_INSTALL="${POLICY_HOME}/install/servers/brmsgw/config.properties"


if [ ! -f "${PROPS_BUILD}" ]; then
	echo "error: version information does not exist: ${PROPS_BUILD}"
	exit 1
fi

source "${POLICY_HOME}/etc/build.info"

if [ -z "${version}" ]; then
	echo "error: no version information present"
	exit 1
fi

for CONFIG in ${PROPS_RUNTIME} ${PROPS_INSTALL}; do
	if [ ! -f "${CONFIG}" ]; then
		echo "warning: configuration does not exist: ${CONFIG}"
	else
		sed -i -e "s/brms.dependency.version=.*/brms.dependency.version=${version}/g" "${CONFIG}"
	fi
done

DEPS_JSON_RUNTIME="${POLICY_HOME}/servers/brmsgw/dependency.json"
DEPS_JSON_INSTALL="${POLICY_HOME}/install/servers/brmsgw/dependency.json"

for DEP in ${DEPS_JSON_RUNTIME} ${DEPS_JSON_INSTALL}; do
	if [ ! -f "${DEP}" ]; then
		echo "warning: configuration does not exist: ${DEP}"
	else
		sed -i -e "s/\"version\":.*-SNAPSHOT\"/\"version\": \"${version}\"/g" "${DEP}"
	fi
done
