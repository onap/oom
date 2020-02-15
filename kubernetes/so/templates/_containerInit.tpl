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

{{- define "container.initConnertainers" -}}
- name: {{ include "common.name" . }}-readiness
  command:
  - /root/job_complete.py
  args:
  - --job-name
  - {{ include "common.release" . }}-so-mariadb-config-job
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  image: "{{ .Values.global.readinessRepository }}/{{ .Values.global.readinessImage }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
{{ if eq .Values.global.aaf.ssl.certs.enabled true -}}
- name: aaf-certs-init-container
  image: {{ include "common.repository" . }}/{{ .Values.global.aaf.ssl.certs.agent_image }}
  imagePullPolicy: {{ .Values.pullPolicy }}
  volumeMounts:
  - mountPath: /opt/app/osaaf/local
    name: aaf-ssl-certs-vol
  command: ["bash","-c","/opt/app/aaf_config/bin/agent.sh; /opt/app/aaf_config/bin/agent.sh ~/.aaf/sso.props showpass|sed -n -E '/^cadi_|^Chal/p' 1> /opt/app/osaaf/local/.passphrases 2>/dev/null; chown -Rf 1000:1000 /opt/app/osaaf/local/;"]
  env:
  - name: APP_FQI
    value: {{ .Values.global.aaf.ssl.certs.app_fqi }}
  - name: aaf_locate_url
    value: https://aaf-locate.{{ .Release.Namespace}}:8095
  - name: aaf_locator_container
    value: {{ .Values.global.aaf.ssl.certs.aaf_locator_container }}
  - name: aaf_locator_container_ns
    value: {{ .Release.Namespace}}
  - name: aaf_locator_fqdn
    value: {{ .Values.global.aaf.ssl.certs.aaf_locator_fqdn }}
  - name: aaf_locator_app_ns
    value: {{ .Values.global.aaf.ssl.certs.aaf_locator_app_ns }}
  - name: DEPLOY_FQI
    value: {{ .Values.global.aaf.ssl.certs.deploy_fqi }}
  - name: DEPLOY_PASSWORD
    valueFrom:
      secretKeyRef:
        name: {{ include "common.release" . }}-so-aaf-ssl-certs-deploy-secret
        key: deployPassword
  - name: cadi_longitude
    value: {{ .Values.global.app.cadi.cadiLongitude | quote}}
  - name: cadi_latitude
    value: {{ .Values.global.app.cadi.cadiLatitude | quote}}
{{- end -}}
{{- end -}}
