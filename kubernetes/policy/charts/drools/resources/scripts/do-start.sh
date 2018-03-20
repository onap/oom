# Copyright © 2017 Amdocs, Bell Canada
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
