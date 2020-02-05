{{/*
# Copyright © 2020 Amdocs, Bell Canada, highstreet technologies GmbH
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
*/}}

{{/*
  {{ include "common.aaf-config" .}}
  usage: {{ include "common.aaf-config" . | nindent 8}}
  Resolve aaf-config init container for to apply to a chart.
  Start parameter for aaf-init to be defined in values
  .Values.aaf_init.fqi
  .Values.aaf_init.fqdn
  .Values.aaf_init.app_ns
  .Values.aaf_init.cadi_longitude
  .Values.aaf_init.public_fqdn
  .Values.aaf_init.persistence.enabled: true
  .Values.aaf_init.persistence.config.volumeReclaimPolicy: Delete
  .Values.aaf_init.persistence.config.accessMode: ReadWriteMany
  .Values.aaf_init.persistence.config.size: 40M
  .Values.aaf_init.persistence.config.storageClass: "manual"
  .Values.aaf_init.persistence.config.mountPath: "/dockerdata-nfs"
  .Values.aaf_init.persistence.config.mountSubPath: "sdnc/aaf"
  .Values.aaf_init.certsaddconfig: additional commands to run after agent.sh
  {{ include "common.aaf-config-volumes .}}
  usage: {{- include "common.aaf-config-volumes" . }}
  Resolves volumes in Volume section of deployment.yaml/statfulset.yaml
  {{ include "common.aaf-config-pvc" . | nindent XX}}
  resolves pvc
  {{ include "common.aaf-config-pv" .}}
  resolves pv

*/}}
{{- define "common.aaf-config" -}}
{{ if .Values.global.aafEnabled }}
- name: {{ include "common.name" . }}-aaf-readiness
  image: "{{ .Values.global.readinessRepository }}/{{ .Values.global.readinessImage }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  command:
  - /root/ready.py
  args:
  - --container-name
  - aaf-locate
  - --container-name
  - aaf-cm
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
- name: {{ include "common.name" . }}-aaf-config
  image: {{ .Values.global.repository }}/{{.Values.aaf_init.image}}
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  volumeMounts:
  - mountPath: "/opt/app/osaaf"
    name: {{ include "common.fullname" . }}-aaf-config-vol
  {{- if .Values.aaf_init.addconfig}}
  - name: aaf-add-config
    mountPath: /opt/app/aaf_config/bin/aaf-add-config.sh
    subPath: aaf-add-config.sh
  {{- end }}
  #NOTE: Before this, need Liveness Attached to aaf-certman
  command:
    - sh
    - -c
    - |
      #!/usr/bin/env bash
      /opt/app/aaf_config/bin/agent.sh
      {{- if .Values.aaf_init.addconfig}}
      /opt/app/aaf_config/bin/aaf-add-config.sh
      {{- end }}
  env:
    - name: APP_FQI
      value: "{{ .Values.aaf_init.fqi }}"
    - name: aaf_locate_url
      value: "https://aaf-locate.{{ .Release.Namespace}}:8095"
    - name: aaf_locator_container
      value: "oom"
    - name: aaf_locator_container_ns
      value: "{{ .Release.Namespace }}"
    - name: aaf_locator_fqdn
      value: "{{ .Values.aaf_init.fqdn }}"
    - name: aaf_locator_app_ns
      value: "{{ .Values.aaf_init.app_ns }}"
    - name: DEPLOY_FQI
      value: "deployer@people.osaaf.org"
  #Note: We want to put this in Secrets or at LEAST ConfigMaps
    - name: DEPLOY_PASSWORD
      value: "demo123456!"
  #Note: want to put this on Nodes, evenutally
    - name: cadi_longitude
      value: "{{ .Values.aaf_init.cadi_longitude }}"
    - name: cadi_latitude
      value: "{{ .Values.aaf_init.cadi_latitude }}"
  #Hello specific.  Clients don't don't need this, unless Registering with AAF Locator
    - name: aaf_locator_public_fqdn
      value: "{{.Values.aaf_init.public_fqdn}}"
{{- end -}}
{{- end -}}


{{- define "common.aaf-config-volume-mountpath" -}}
{{ if .Values.global.aafEnabled }}
- mountPath: "/opt/app/osaaf"
  name: {{ include "common.fullname" . }}-aaf-config-vol
{{- end -}}
{{- end -}}

{{- define "common.aaf-config-volumes" -}}
{{ if .Values.global.aafEnabled }}
- name: {{ include "common.fullname" . }}-aaf-config-vol
  persistentVolumeClaim:
    claimName: {{ include "common.fullname" . }}-aaf-config-pvc
{{- if .Values.aaf_init.addconfig }}
- name: aaf-add-config
  configMap:
    name: {{ include "common.fullname" . }}-aaf-add-config
    defaultMode: 0700
{{- end }}
{{- end -}}
{{- end }}

{{- define "common.aaf-config-pv" -}}
metadata:
  name: {{ include "common.fullname" . }}-aaf-config-pv
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}-aaf-config-pv
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
    name: {{ include "common.fullname" . }}
spec:
  capacity:
    storage: {{ .Values.aaf_init.persistence.config.size}}
  accessModes:
    - {{ .Values.aaf_init.persistence.config.accessMode }}
  persistentVolumeReclaimPolicy: {{ .Values.aaf_init.persistence.config.volumeReclaimPolicy }}
  hostPath:
     path: {{ .Values.aaf_init.persistence.config.mountPath }}/{{ .Release.Name }}/{{ .Values.aaf_init.persistence.config.mountSubPath }}
{{- if .Values.aaf_init.persistence.config.storageClass }}
{{- if (eq "-" .Values.aaf_init.persistence.config.storageClass) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ .Values.aaf_init.persistence.config.storageClass }}"
{{- end }}
{{- end }}
{{- end -}}

{{- define "common.aaf-config-pvc" -}}
metadata:
  name: {{ include "common.fullname" . }}-aaf-config-pvc
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
{{- if .Values.aaf_init.persistence.annotations }}
  annotations:
{{ toYaml .Values.aaf_init.persistence.annotations | indent 4 }}
{{- end }}
spec:
  selector:
    matchLabels:
      app: {{ include "common.name" . }}-aaf-config-pv
  accessModes:
    - {{ .Values.aaf_init.persistence.config.accessMode }}
  resources:
    requests:
      storage: {{ .Values.aaf_init.persistence.config.size }}
{{- if .Values.aaf_init.persistence.config.storageClass }}
{{- if (eq "-" .Values.aaf_init.persistence.config.storageClass) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ .Values.aaf_init.persistence.config.storageClass }}"
{{- end }}
{{- end }}
{{- end -}}
