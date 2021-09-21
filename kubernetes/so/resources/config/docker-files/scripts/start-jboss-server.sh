#!/bin/sh
{{/*
# Copyright 2015 AT&T Intellectual Properties
##############################################################################
#       Script to initialize the chef-repo branch and.chef
#
##############################################################################
*/}}
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
if [ "$JBOSS_PIDFILE" != "" ]; then
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
if [ "$JBOSS_PIDFILE" != "" ]; then
      grep "$JBOSS_PID" $JBOSS_PIDFILE && rm $JBOSS_PIDFILE
fi
