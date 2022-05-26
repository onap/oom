#!/bin/sh

# Copyright 2019 AT&T Intellectual Property. All rights reserved.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#         http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

THIS_DIR="$( cd "$( dirname "$0" )" >/dev/null 2>&1 && pwd )"

NAMESPACE=
FOLDER=
POLL=0

check_required_parameter () {
  # arg1 = parameter
  # arg2 = parameter name
  if [ -z "$1" ]; then
    echo "$2 was not was provided. This parameter is required."
    exit 1
  fi
}

check_optional_paramater () {
  # arg1 = parameter
  # arg2 = parameter name
  if [ -z $1 ]; then
    echo "$2"
  else
    echo "$1"
  fi
}

while test $# -gt 0; do
  case "$1" in
    -h|--help)
      echo "./instantiate-k8s.sh [options]"
      echo " "
      echo "required:"
      echo "-n, --namespace <namespace>       namespace that robot pod is running under."
      echo "-f, --folder <folder>             path to folder containing heat templates, preloads, and vnf-details.json."
      echo " "
      echo "additional options:"
      echo "-p, --poll                        some cloud environments (like azure) have a short time out value when executing"
      echo "                                  kubectl. If your shell exits before the testsuite finishes, using this option"
      echo "                                  will poll the testsuite logs every 30 seconds until the test finishes."
      echo " "
      echo "This script executes the VNF instantiation robot testsuite."
      echo "- It copies the VNF folder to the robot container that is part of the ONAP deployment."
      echo "- It models, distributes, and instantiates a heat-based VNF."
      echo "- It copies the logs to an output directory, and creates a tarball for upload to the OVP portal."
      echo ""
      exit 0
      ;;
    -n|--namespace)
      shift
      NAMESPACE=$1
      shift
      ;;
    -f|--folder)
      shift
      FOLDER=$1
      shift
      ;;
    -p|--poll)
      shift
      POLL=1
      ;;
    *)
      echo "Unknown Argument $1. Try running with --help."
      exit 0
      ;;
  esac
done

check_required_parameter "$NAMESPACE" "--namespace"
check_required_parameter "$FOLDER" "--folder"

TAG="instantiate_vnf_ovp"

if [ ! -d "$FOLDER" ]; then
  echo "VNF folder $FOLDER does not exist, exiting."
  exit 1
fi

BUILDNUM="$$"
OUTPUT_DIRECTORY=/tmp/vnfdata.${BUILDNUM}

set -x

POD=$(kubectl --namespace $NAMESPACE get pods | sed 's/ .*//'| grep robot)
export GLOBAL_BUILD_NUMBER=$(kubectl --namespace $NAMESPACE exec  ${POD}  -- sh -c "ls -1q /share/logs/ | wc -l")
TAGS="-i $TAG"
ETEHOME=/var/opt/ONAP
OUTPUT_FOLDER=$(printf %04d $GLOBAL_BUILD_NUMBER)_ete_instantiate_vnf
DISPLAY_NUM=$(($GLOBAL_BUILD_NUMBER + 90))
VARIABLEFILES="-V /share/config/robot_properties.py"
VARIABLES="$VARIABLES -v GLOBAL_BUILD_NUMBER:${BUILDNUM}"

echo "Copying the VNF folder into robot pod..."
kubectl --namespace $NAMESPACE cp $FOLDER ${POD}:/tmp/vnfdata.${BUILDNUM}


echo "Executing instantiation..."

if [ $POLL = 1 ]; then
  kubectl --namespace $NAMESPACE exec ${POD} -- sh -c "${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/${OUTPUT_FOLDER} ${TAGS} --listener ${ETEHOME}/testsuite/eteutils/robotframework-onap/listeners/OVPListener.py --display $DISPLAY_NUM > /tmp/vnf_instantiation.$BUILDNUM.log 2>&1 &"

  pid=`kubectl --namespace $NAMESPACE exec ${POD} -- sh -c "pgrep runTags.sh -n"`

  if [ -z "$pid" ]; then
    echo "robot testsuite unable to start"
    exit 1
  fi

  kubectl --namespace $NAMESPACE exec ${POD} -- sh -c "while ps -p \"$pid\" --no-headers | grep -v defunct; do echo \$'\n\n'; echo \"Testsuite still running \"\`date\`; echo \"LOG FILE: \"; tail -10 /tmp/vnf_instantiation.$BUILDNUM.log; sleep 30; done"

else
  kubectl --namespace $NAMESPACE exec ${POD} -- sh -c "${ETEHOME}/runTags.sh ${VARIABLEFILES} ${VARIABLES} -d /share/logs/${OUTPUT_FOLDER} ${TAGS} --listener ${ETEHOME}/testsuite/eteutils/robotframework-onap/listeners/OVPListener.py --display $DISPLAY_NUM"
fi

set +x

echo "testsuite has finished"

mkdir -p "$OUTPUT_DIRECTORY"
echo "Copying Results from pod..."

kubectl --namespace $NAMESPACE cp ${POD}:share/logs/$OUTPUT_FOLDER/summary/report.json "$OUTPUT_DIRECTORY"/report.json
kubectl --namespace $NAMESPACE cp ${POD}:share/logs/$OUTPUT_FOLDER/summary/stack_report.json "$OUTPUT_DIRECTORY"/stack_report.json
kubectl --namespace $NAMESPACE cp ${POD}:share/logs/$OUTPUT_FOLDER/summary/results.json "$OUTPUT_DIRECTORY"/results.json
kubectl --namespace $NAMESPACE cp ${POD}:share/logs/$OUTPUT_FOLDER/log.html "$OUTPUT_DIRECTORY"/log.html

initdir=$(pwd)

# echo -e "import hashlib\nwith open(\"README.md\", \"r\") as f: bytes = f.read()\nreadable_hash = hashlib.sha256(bytes).hexdigest()\nprint(readable_hash)" | python

cd "$OUTPUT_DIRECTORY"
tar -czvf vnf_heat_results.tar.gz *

cd $initdir

echo "VNF test results: $OUTPUT_DIRECTORY/vnf_heat_results.tar.gz"
