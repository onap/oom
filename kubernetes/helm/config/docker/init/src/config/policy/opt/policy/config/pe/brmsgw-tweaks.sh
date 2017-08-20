#! /bin/bash

PROPS_BUILD="${POLICY_HOME}/etc/build.info"

PROPS_RUNTIME="${POLICY_HOME}/servers/brmsgw/config.properties"
PROPS_INSTALL="${POLICY_HOME}/install/servers/brmsgw/config.properties"


if [ ! -f "${PROPS_BUILD}" ]; then
	echo "error: version information does not exist: ${PROPS_BUILD}"
	exit 1
fi

source "${POLICY_HOME}/etc/build.info"

for CONFIG in ${PROPS_RUNTIME} ${PROPS_INSTALL}; do
	if [ ! -f "${CONFIG}" ]; then
		echo "warning: configuration does not exist: ${CONFIG}"
	else
		if [ -n "${version}" ]; then
			/bin/sed -i -e "s/brms.dependency.version=.*/brms.dependency.version=${version}/g" "${CONFIG}"
		else
			echo "error: no version information present"
		fi
	fi
done
