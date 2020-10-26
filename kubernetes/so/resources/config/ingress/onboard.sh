#!/bin/sh
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

export CRT=$(cat /opt/app/osaaf/certs/tls.crt | base64)
export KEY=$(cat /opt/app/osaaf/certs/tls.key | base64)
cat > secret.yaml <<- EOF
apiVersion: v1
kind: Secret
metadata:
  name: {{ include "common.release" . }}-so-ingress-certs
  namespace: {{ include "common.namespace" . }}
data:
  tls.crt: "${CRT}"
  tls.key: '${KEY}'
type: kubernetes.io/tls
EOF
kubectl apply -f secret.yaml