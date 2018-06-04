#! /bin/bash -xv

# Copyright © 2017-2018 Amdocs, Bell Canada, AT&T
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


"${POLICY_HOME}"/bin/features enable healthcheck
"${POLICY_HOME}"/bin/features enable distributed-locking

"${POLICY_HOME}"/bin/db-migrator -s pooling -o upgrade

# make sure the PDPD-CONFIGURATION anonymous topic is created
# so not to lose any configuration updates

echo
echo "testing publish to PDPD-CONFIGURATION topic"
echo

curl --silent --connect-timeout 15 -X POST --header "Content-Type: application/json" -d "{}"   http://message-router:3904/events/PDPD-CONFIGURATION

echo
echo "testing subscribe to PDPD-CONFIGURATION topic "
echo

curl --silent --connect-timeout 15 -X GET http://message-router:3904/events/PDPD-CONFIGURATION/1/1?timeout=5000

# for resiliency/scalability scenarios, check to see
# if there's an amsterdam artifact  already deployed
# by brmsgw.  If so, update the amsterdam controller
# coordinates.  In the future, a more sophisticated
# solution will be put in place, that will required
# coordination among policy components.

echo
echo "checking if there are amsterdam policies already deployed .."
echo

AMSTERDAM_VERSION=$(curl --silent --connect-timeout 20 -X GET "http://nexus:8081/nexus/service/local/artifact/maven/resolve?r=releases&g=org.onap.policy-engine.drools.amsterdam&a=policy-amsterdam-rules&v=RELEASE" | grep -Po "(?<=<version>).*(?=</version>)")

if [[ -z ${AMSTERDAM_VERSION} ]]; then
	echo "no amsterdam policies have been found .."
	exit 0
fi

echo
echo "The latest deployed amsterdam artifact in nexus has version ${AMSTERDAM_VERSION}"
echo

sed -i.INSTALL -e "s/^rules.artifactId=.*/rules.artifactId=policy-amsterdam-rules/g" \
               -e "s/^rules.groupId=.*/rules.groupId=org.onap.policy-engine.drools.amsterdam/g" \
               -e "s/^rules.version=.*/rules.version=${AMSTERDAM_VERSION}/g" "${POLICY_HOME}"/config/amsterdam-controller.properties

echo
echo "amsterdam controller will be started brained with maven coordinates:"
echo

grep "^rules" "${POLICY_HOME}"/config/amsterdam-controller.properties

echo
echo
