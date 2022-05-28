#!/bin/sh

# Copyright (c) 2017 AT&T Intellectual Property. All rights reserved.
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

#
# Run the health-check testsuites for the tags discovered by helm list
# Please clean up logs when you are done...
#
if [ "$1" = "" ] ;  then
   echo "Usage: eteHelm-k8s.sh [namespace] [execscript]"
   echo " list projects via helm list and runs health-check with those tags except dev and dev-consul"
   echo " [execscript] - optional parameter to execute user custom scripts located in scripts/helmscript directory"
   exit
fi

set -x

export NAMESPACE="$1"

POD=$(kubectl --namespace $NAMESPACE get pods | sed 's/ .*//'| grep robot)

PROJECTS=$(helm list | tail -n +3 | grep '-' | cut -d' ' -f1 | sed -E 's/\w+-(\w+)/health-\1/g' | grep -v consul | grep -v nfs-provision)

TAGS=""
for project in $PROJECTS ;
do
TAGS="$TAGS -i $project"
done

DIR=$(dirname "$0")
SCRIPTDIR=scripts/helmscript

ETEHOME=/var/opt/ONAP

if [ "${!#}" = "execscript" ]; then
   for script in $(ls -1 "$DIR/$SCRIPTDIR"); do
      [ -f "$DIR/$SCRIPTDIR/$script" ] && [ -x "$DIR/$SCRIPTDIR/$script" ] && . "$DIR/$SCRIPTDIR/$script"
   done
fi

export GLOBAL_BUILD_NUMBER=$(kubectl --namespace $NAMESPACE exec  ${POD}  -- sh -c "ls -1q /share/logs/ | wc -l")
OUTPUT_FOLDER=$(printf %04d $GLOBAL_BUILD_NUMBER)_ete_helmlist
DISPLAY_NUM=$(($GLOBAL_BUILD_NUMBER + 90))

VARIABLEFILES="-V /share/config/robot_properties.py"
VARIABLES="-v GLOBAL_BUILD_NUMBER:$$"

kubectl --namespace $NAMESPACE exec ${POD} -- ${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/${OUTPUT_FOLDER} ${TAGS} --display $DISPLAY_NUM
