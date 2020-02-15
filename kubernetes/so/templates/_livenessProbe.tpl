
# Copyright © 2018 AT&T USA
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
{{- define "helpers.livenessProbe" -}} 
livenessProbe:
  httpGet:
    path: {{ index .Values.livenessProbe.path}}
    port: {{ include "helpers.profileProperty" (dict "condition" .Values.global.aaf.ssl.certs.enabled "value1" 8443 "value2"  .Values.containerPort ) }}
    scheme: {{ include "helpers.profileProperty" (dict "condition" .Values.global.aaf.ssl.certs.enabled "value1" "HTTPS" "value2" .Values.livenessProbe.scheme ) }}
    {{- if eq .Values.global.security.aaf.enabled true }}
    httpHeaders:
    - name: Authorization
      value: {{ index .Values.global.aaf.auth.header }}
    {{- end }}
  initialDelaySeconds: {{ index .Values.livenessProbe.initialDelaySeconds}}
  periodSeconds: {{ index .Values.livenessProbe.periodSeconds}}
  timeoutSeconds: {{ index .Values.livenessProbe.timeoutSeconds}}
  successThreshold: {{ index .Values.livenessProbe.successThreshold}}
  failureThreshold: {{ index .Values.livenessProbe.failureThreshold}}
{{- end -}}
