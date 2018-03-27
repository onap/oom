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

#!/bin/sh
# Copyright 2015 AT&T Intellectual Properties
##############################################################################
#       Script to initialize the chef-repo branch and.chef
#
##############################################################################
# Copy the certificates
echo 'Copying the *.crt provided in /shared folder'
cp --verbose /shared/*.crt /usr/local/share/ca-certificates
update-ca-certificates

echo 'Running in JBOSS'
su - jboss

DEBUG=''
if [ "$JBOSS_DEBUG" = true ] ; then
  DEBUG="--debug"
fi

#Start the chef-solo if mso-docker.json contains some data.
if [ -s /var/berks-cookbooks/${CHEF_REPO_NAME}/environments/mso-docker.json ]
then
	echo "mso-docker.json has some configuration, replay the recipes."
	chef-solo -c /var/berks-cookbooks/${CHEF_REPO_NAME}/solo.rb -o recipe[mso-config::apih],recipe[mso-config::bpmn],recipe[mso-config::jra]
else
	echo "mso-docker.json is empty, do not replay the recipes."
fi

JBOSS_PIDFILE=/tmp/jboss-standalone.pid
$JBOSS_HOME/bin/standalone.sh ${DEBUG} -c standalone-full-ha-mso.xml &
JBOSS_PID=$!
# Trap common signals and relay them to the jboss process
trap "kill -HUP  $JBOSS_PID" HUP
trap "kill -TERM $JBOSS_PID" INT
trap "kill -QUIT $JBOSS_PID" QUIT
trap "kill -PIPE $JBOSS_PID" PIPE
trap "kill -TERM $JBOSS_PID" TERM
if [ "x$JBOSS_PIDFILE" != "x" ]; then
  echo $JBOSS_PID > $JBOSS_PIDFILE
fi
# Wait until the background process exits
WAIT_STATUS=128
while [ "$WAIT_STATUS" -ge 128 ]; do
   wait $JBOSS_PID 2>/dev/null
   WAIT_STATUS=$?
   if [ "$WAIT_STATUS" -gt 128 ]; then
      SIGNAL=`expr $WAIT_STATUS - 128`
      SIGNAL_NAME=`kill -l $SIGNAL`
      echo "*** JBossAS process ($JBOSS_PID) received $SIGNAL_NAME signal ***" >&2
   fi
done
if [ "$WAIT_STATUS" -lt 127 ]; then
   JBOSS_STATUS=$WAIT_STATUS
else
   JBOSS_STATUS=0
fi
if [ "$JBOSS_STATUS" -ne 10 ]; then
      # Wait for a complete shudown
      wait $JBOSS_PID 2>/dev/null
fi
if [ "x$JBOSS_PIDFILE" != "x" ]; then
      grep "$JBOSS_PID" $JBOSS_PIDFILE && rm $JBOSS_PIDFILE
fi
