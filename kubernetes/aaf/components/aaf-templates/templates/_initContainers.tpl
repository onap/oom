{*/
# Copyright © 2020 AT&T, Orange
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
*/}

{{- define "aaf.permissionFixer" -}}
- name: onboard-identity-and-fix-permission
  command:
  - /bin/sh
  args:
  - -c
  - |
    echo "*** Move files from configmap to emptyDir"
    cp -L /config-input-identity/* /config-identity/
    echo "*** set righ user to the different folders"
    chown -R 1000:1000 /config-identity
    chown -R 1000:1000 /opt/app/aaf
    chown -R 1000:1000 /opt/app/osaaf
  image: {{ include "repositoryGenerator.image.busybox" . }}
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  volumeMounts:
  - mountPath: /opt/app/osaaf
    name: aaf-config-vol
  - mountPath: /config-input-identity
    name: config-init-identity
  - mountPath: /config-identity
    name: config-identity
  resources:
    limits:
      cpu: 100m
      memory: 100Mi
    requests:
      cpu: 3m
      memory: 20Mi
{{- end -}}

{{- define "aaf.podConfiguration" }}
- name: {{ include "common.name" . }}-config-container
  image: {{ include "repositoryGenerator.repository" . }}/{{.Values.global.aaf.config.image}}
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  command:
  - /bin/bash
  args:
  - -c
  - |
    cd /opt/app/aaf_config
    bin/agent.sh
  volumeMounts:
  - mountPath: "/opt/app/osaaf"
    name: aaf-config-vol
  - name: aaf-agent-certs
    mountPath: /opt/app/aaf_config/cert/truststoreONAPall.jks.b64
    subPath: truststoreONAPall.jks.b64
  - name: aaf-agent-certs
    mountPath: /opt/app/aaf_config/cert/truststoreONAP.p12.b64
    subPath: truststoreONAP.p12.b64
  - name: aaf-agent-certs
    mountPath: /opt/app/aaf_config/cert/demoONAPsigner.p12.b64
    subPath: demoONAPsigner.p12.b64
  - name: ca-certs
    mountPath: /opt/app/aaf_config/cert/intermediate_root_ca.pem
    subPath: intermediate_root_ca.pem
    readOnly: true
  - name: ca-certs
    mountPath: /opt/app/aaf_config/cert/AAF_RootCA.cer
    subPath: AAF_RootCA.cer
    readOnly: true
  env:
  - name: aaf_env
    value: "{{ .Values.global.aaf.aaf_env }}"
  - name: cadi_latitude
    value: "{{ .Values.global.aaf.cadi_latitude }}"
  - name: cadi_longitude
    value: "{{ .Values.global.aaf.cadi_longitude }}"
  - name: cadi_x509_issuers
    value: "{{ .Values.global.aaf.cadi_x509_issuers }}"
  - name: aaf_locate_url
    value: "https://aaf-locate.{{ .Release.Namespace}}:8095"
  - name: aaf_locator_container
    value: "oom"
  - name: aaf_release
    value: "{{ .Values.global.aaf.aaf_release }}"
  - name: aaf_locator_container_ns
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  - name: aaf_locator_public_fqdn
    value: "{{.Values.global.aaf.public_fqdn}}"
  - name: aaf_locator_name
    value: "{{.Values.global.aaf.aaf_locator_name}}"
  - name: aaf_locator_name_oom
    value: "{{.Values.global.aaf.aaf_locator_name_oom}}"
  - name: cm_always_ignore_ips
    value: "true"
  - name: CASSANDRA_CLUSTER
    value: "aaf-cass.{{ .Release.Namespace }}"
  resources:
    limits:
      cpu: 100m
      memory: 100Mi
    requests:
      cpu: 3m
      memory: 20Mi
{{- end -}}

{{- define "aaf.initContainers" -}}
initContainers:
{{   include "aaf.permissionFixer"  . }}
{{-   if .Values.sequence_order }}
- name: {{ include "common.name" . }}-aaf-readiness
  command:
  - /app/ready.py
  args:
  {{- range $container := .Values.sequence_order }}
  - --container-name
  - aaf-{{ $container}}
  {{- end }}
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  image: {{ include "repositoryGenerator.image.readiness" . }}
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  resources:
    limits:
      cpu: 100m
      memory: 100Mi
    requests:
      cpu: 3m
      memory: 20Mi
{{-   end }}
{{   include "aaf.podConfiguration" . }}
{{- end }}
