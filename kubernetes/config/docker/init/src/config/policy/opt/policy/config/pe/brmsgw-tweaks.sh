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
