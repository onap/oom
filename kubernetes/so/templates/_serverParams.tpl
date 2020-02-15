
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
{{- define "server.params" -}}
{{- if eq .Values.global.aaf.ssl.certs.enabled true -}}
port: {{ .Values.containerSslPort}}
ssl:
  key-store-type: JKS
  key-store: certs/org.onap.so.jks
  key-store-password: ${CADI_KEYSTORE_PASSWORD}
  trust-store: certs/org.onap.so.trust.jks
  trust-store-password: ${CADI_TRUSTSTORE_PASSWORD}
{{- else -}}
port: {{ .Values.containerPort}}
ssl-enable: false
{{- end }}
tomcat:
  max-threads: 50
{{- end -}}
