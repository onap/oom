#!/bin/bash

# skip installation if build.info file is present (restarting an existing container)
if [[ -f /opt/app/policy/etc/build.info ]]; then
	echo "Found existing installation, will not reinstall"
	. /opt/app/policy/etc/profile.d/env.sh
else 
	# replace conf files from installer with environment-specific files
	# mounted from the hosting VM
	if [[ -d config ]]; then
		cp config/*.conf .
	fi

	./docker-install.sh

	. /opt/app/policy/etc/profile.d/env.sh

	# install policy keystore
	mkdir -p $POLICY_HOME/etc/ssl
	cp config/policy-keystore $POLICY_HOME/etc/ssl

	if [[ -x config/drools-tweaks.sh ]] ; then
		echo "Executing tweaks"
		# file may not be executable; running it as an
		# argument to bash avoids needing execute perms.
		bash config/drools-tweaks.sh
	fi

	# sql provisioning scripts should be invoked here.
fi

echo "Starting processes"

policy start

sleep 1000d
