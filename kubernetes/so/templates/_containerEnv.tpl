
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
{{- define "container.env" -}}
- name: DB_HOST
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-db-secrets
      key: mariadb.readwrite.host
- name: DB_PORT
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-db-secrets
      key: mariadb.readwrite.port
- name: DB_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-db-secrets
      key: mariadb.readwrite.rolename
- name: DB_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-db-secrets
      key: mariadb.readwrite.password
- name: DB_ADMIN_USERNAME
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-db-secrets
      key: mariadb.admin.rolename
- name: DB_ADMIN_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-db-secrets
      key: mariadb.admin.password
 {{- if eq .Values.global.security.aaf.enabled true }}
- name: TRUSTSTORE
  value: {{ .Values.global.client.certs.truststore }}
- name: TRUSTSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-client-certs-pwd-secret
      key: trustStorePassword
- name: KEYSTORE
  value: {{ .Values.global.client.certs.keystore }}
- name: KEYSTORE_PASSWORD
  valueFrom:
    secretKeyRef:
      name: {{ include "common.release" . }}-so-client-certs-pwd-secret
      key: keyStorePassword
{{- end }}
{{- if eq .Values.global.aaf.ssl.certs.enabled true }}
- name: AAF_SSL_CERTS_ENABLED
  value: {{ .Values.global.aaf.ssl.certs.enabled |quote }}
{{- end }}
envFrom:
- configMapRef:
    name: {{ include "common.fullname" . }}-configmap
{{- end -}}
