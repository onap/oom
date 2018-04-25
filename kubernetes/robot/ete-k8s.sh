#!/bin/bash

#
# Run the testsuite for the passed tag. Valid tags are ete, health, closedloop, instantiate
# Please clean up logs when you are done...
# Note: Do not run multiple concurrent ete.sh as the --display is not parameterized and tests will collide
#
if [ "$1" == "" ] || [ "$2" == "" ]; then
   echo "Usage: ete-k8s.sh [namespace] [ health | ete | closedloop | instantiate | distribute ]"
   exit
fi


export NAMESPACE="$1"

POD=$(kubectl --namespace $NAMESPACE get pods | sed 's/ .*//'| grep robot)


export TAGS="-i $2"
export ETEHOME=/var/opt/OpenECOMP_ETE
export GLOBAL_BUILD_NUMBER=$(kubectl --namespace $NAMESPACE exec  ${POD}  -- bash -c "ls -1q /share/logs/ | wc -l")
export OUTPUT_FOLDER=ETE_$(printf %04d $GLOBAL_BUILD_NUMBER)_$2

#export OUTPUT_FOLDER=ETE_$$

VARIABLEFILES="-V /share/config/vm_properties.py -V /share/config/integration_robot_properties.py -V /share/config/integration_preload_parameters.py"
VARIABLES="-v GLOBAL_BUILD_NUMBER:$$"

kubectl --namespace $NAMESPACE exec ${POD} -- ${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/${OUTPUT_FOLDER} ${TAGS} --display 88

