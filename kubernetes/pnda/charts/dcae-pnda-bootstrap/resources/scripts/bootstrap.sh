#!/bin/sh
# ================================================================================
# Copyright (c) 2018 Cisco Systems. All rights reserved.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================

# Install PNDA in Openstack with Heat templates
# Expects:
#   Input files for components to be installed in /inputs

if [ "z{{ .Values.enabled }}" != "ztrue" ]
then
   echo
   echo "PNDA bootstrap is disabled - skipping pnda-cli launch"
   echo
   exit 0
fi

set -ex

CLUSTER_PREFIX="{{ .Release.Name }}-{{ include "common.namespace" . }}-pnda"
DATANODES="{{ .Values.pnda.dataNodes }}"
KAFKANODES="{{ .Values.pnda.kafkaNodes }}"
VERSION="{{ .Values.pnda.version }}"
KEYPAIR_NAME="{{ .Values.pnda_keypair_name }}"
KEYFILE="$KEYPAIR_NAME.pem"

cd /pnda-cli

cp /inputs/pnda_env.yaml .
cp /secrets/pnda.pem $KEYFILE
chmod 600 $KEYFILE

(cd tools && ./gen-certs.py)

KUBE_API="https://$KUBERNETES_SERVICE_HOST:$KUBERNETES_SERVICE_PORT_HTTPS/api/v1"
KUBE_TOKEN=$(cat /var/run/secrets/kubernetes.io/serviceaccount/token)

for i in 1 2 3 4 5 6 7 8 9
do
  MIRROR_IP=$(curl -s $KUBE_API/namespaces/{{ include "common.namespace" . }}/pods \
            --header "Authorization: Bearer $KUBE_TOKEN" \
            --insecure | jq -r '.items[].status | select(.containerStatuses != null) | select(.containerStatuses[].ready and .containerStatuses[].name=="dcae-pnda-mirror") | .hostIP')
  MIRROR_PORT=$(curl -s $KUBE_API/namespaces/{{ include "common.namespace" . }}/services/dcae-pnda-mirror \
              --header "Authorization: Bearer $KUBE_TOKEN" \
              --insecure | jq -r '.spec.ports[] | select(.name=="dcae-pnda-mirror") | .nodePort')

  if [ "x${MIRROR_IP}" != "xnull" -a "x${MIRROR_PORT}" != "xnull" ]; then
    PNDA_MIRROR="http://$MIRROR_IP:$MIRROR_PORT"
    break
  fi
  sleep 5
done

[ -z "${PNDA_MIRROR}" ] && { echo "Unable to get PNDA mirror IP:PORT"; exit 1; }

sed -i -e 's?CLIENT_IP/32?CLIENT_IP?' bootstrap-scripts/package-install.sh

./cli/pnda-cli.py create -e $CLUSTER_PREFIX -f pico -n $DATANODES -k $KAFKANODES \
                  -b $VERSION -s $KEYPAIR_NAME --set "mirrors.PNDA_MIRROR=$PNDA_MIRROR"
