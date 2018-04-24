# Copyright © 2017 Amdocs, Bell Canada, AT&T
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

#!/bin/bash

# Script to configure and start the Policy components that are to run in the designated container,
# It is intended to be used as the entrypoint in the Dockerfile, so the last statement of the
# script just goes into a long sleep so that the script does not exit (which would cause the
# container to be torn down).

container=$1

case $container in
pap)
	comps="base pap paplp console mysql elk"
	;;
pdp)
	comps="base pdp pdplp"
	;;
brmsgw)
	comps="base brmsgw"
	;;
*)
	echo "Usage: do-start.sh pap|pdp|brmsgw" >&2
	exit 1
esac


# skip installation if build.info file is present (restarting an existing container)
if [[ -f /opt/app/policy/etc/build.info ]]; then
	echo "Found existing installation, will not reinstall"
	. /opt/app/policy/etc/profile.d/env.sh

else 
	if [[ -d config ]]; then
		cp config/*.conf .
	fi

	for comp in $comps; do
		echo "Installing component: $comp"
		./docker-install.sh --install $comp
	done
	for comp in $comps; do
		echo "Configuring component: $comp"
		./docker-install.sh --configure $comp
	done

	. /opt/app/policy/etc/profile.d/env.sh

	# install keystore
	#changed to use http instead of http, so keystore no longer needed
	#cp config/policy-keystore.jks $POLICY_HOME/etc/ssl/policy-keystore
	
	if [[ -f config/$container-tweaks.sh ]] ; then
		# file may not be executable; running it as an
		# argument to bash avoids needing execute perms.
		bash config/$container-tweaks.sh
	fi

	if [[ $container == pap ]]; then
		# wait for DB up
		# now that DB is up, invoke database upgrade
		# (which does nothing if the db is already up-to-date)
		dbuser=$(echo $(grep '^JDBC_USER=' base.conf | cut -f2 -d=))
		dbpw=$(echo $(grep '^JDBC_PASSWORD=' base.conf | cut -f2 -d=))
		db_upgrade_remote.sh $dbuser $dbpw {{.Values.global.mariadb.nameOverride}}
	fi

fi

policy.sh start

# on pap, wait for pap, pdp, brmsgw, nexus and drools up,
# then push the initial default policies
if [[ $container == pap ]]; then
	# wait addional 1 minute for all processes to get fully initialized and synched up
	sleep 60
	bash -xv config/push-policies.sh
fi

sleep 1000d
