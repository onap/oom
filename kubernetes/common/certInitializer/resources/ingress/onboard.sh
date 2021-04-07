#!/bin/sh

{{/*
# Copyright © 2020 Orange
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
*/ -}}

echo "*** retrieving certificates and keys"
export CRT=$(cat {{ .Values.credsPath }}/certs/tls.crt | base64 -w 0)
export KEY=$(cat {{ .Values.credsPath }}/certs/tls.key | base64 -w 0)
export CACERT=$(cat {{ .Values.credsPath }}/certs/cacert.pem | base64 -w 0)
echo "*** creating tls secret"
cat <<EOF | kubectl apply -f -
apiVersion: v1
kind: Secret
metadata:
  name: {{ tpl .Values.ingressTlsSecret . }}
  namespace: {{ include "common.namespace" . }}
data:
  ca.crt: "${CACERT}"
  tls.crt: "${CRT}"
  tls.key: '${KEY}'
type: kubernetes.io/tls
EOF
