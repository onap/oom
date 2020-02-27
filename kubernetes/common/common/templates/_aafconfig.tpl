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
  common templates to enable aaf configs for applictaions

  Parameter for aafConfig to be defined in values.yaml
  aafConfig:   --> if a different key is used, call templates with argument (dict "aafRoot" "<yourkey>" "dot" .)
    # additional scripts can be defined to handle certs
    addconfig: true|false
    fqdn: "sdnc"
    image: onap/aaf/aaf_agent:2.1.15
    app_ns: "org.osaaf.aaf"
    fqi: "sdnc@sdnc.onap.org"
    fqi_namespace: org.onap.sdnc
    public_fqdn: "aaf.osaaf.org"
    aafDeployFqi: "deployer@people.osaaf.org"
    aafDeployPass: demo123456!
    cadi_latitude: "38.0"
    cadi_longitude: "-72.0"
    persistence:
      enabled: true
      config.volumeReclaimPolicy: Delete
      config.accessMode: ReadWriteMany
      config.size: 40M
      config.storageClass: "manual"
      config.mountPath: "/dockerdata-nfs"
      config.mountSubPath: "sdnc/aaf"
  # secrets configuration, Note: create a secrets template
  secrets:
    - uid: aaf-deploy-creds
      type: basicAuth
      externalSecret: '{{ ternary (tpl (default "" .Values.aafConfig.aafDeployCredsExternalSecret) .) "aafIsDiabled" .Values.global.aafEnabled }}'
      login: '{{ .Values.aafConfig.aafDeployFqi }}'
      password: '{{ .Values.aafConfig.aafDeployPass }}'
      passwordPolicy: required

  In deployments/jobs/stateful include:
  initContainers:
    {{ include "common.aaf-config" . | nindent XX}}

  containers:
    volumeMounts:
    {{- if .Values.global.aafEnabled }}
     - mountPath: "/opt/app/osaaf"
       name: {{ include "common.fullname" . }}-aaf-config-vol
       {{- end }}
  volumes:
  {{- include "common.aaf-config-volumes" . | nindent XX}}

  If persistence.enabled = true
  Create pvc:
  {{ include "common.aaf-config-pvc" . }}
  Create pv
  {{ include "common.aaf-config-pv" . }}

*/}}
{{- define "common.aaf-config" -}}
{{- $dot := default . .dot -}}
{{- $aafRoot := default "aafConfig" .aafRoot -}}
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
  - --container-name
  - aaf-service

  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
- name: {{ include "common.name" . }}-aaf-config
  image: {{ .Values.global.repository }}/{{index .Values $aafRoot "image" }}
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  volumeMounts:
  - mountPath: "/opt/app/osaaf"
    name: {{ include "common.fullname" . }}-aaf-config-vol
  {{- if (index .Values $aafRoot "addconfig") }}
  - name: aaf-add-config
    mountPath: /opt/app/aaf_config/bin/aaf-add-config.sh
    subPath: aaf-add-config.sh
  {{- end }}
  command:
    - sh
    - -c
    - |
      #!/usr/bin/env bash
      /opt/app/aaf_config/bin/agent.sh
      {{- if (index .Values $aafRoot "addconfig") }}
      /opt/app/aaf_config/bin/aaf-add-config.sh
      {{- end }}
  env:
    - name: APP_FQI
      value: "{{ index .Values $aafRoot "fqi" }}"
    - name: aaf_locate_url
      value: "https://aaf-locate.{{ .Release.Namespace}}:8095"
    - name: aaf_locator_container
      value: "oom"
    - name: aaf_locator_container_ns
      value: "{{ .Release.Namespace }}"
    - name: aaf_locator_fqdn
      value: "{{ index .Values $aafRoot "fqdn" }}"
    - name: aaf_locator_app_ns
      value: "{{ index .Values $aafRoot "app_ns" }}"
    - name: DEPLOY_FQI
    {{- include "common.secret.envFromSecret" (dict "global" . "uid" "aaf-deploy-creds" "key" "login") | indent 6 }}
    - name: DEPLOY_PASSWORD
    {{- include "common.secret.envFromSecret" (dict "global" . "uid" "aaf-deploy-creds" "key" "password") | indent 6 }}
  #Note: want to put this on Nodes, evenutally
    - name: cadi_longitude
      value: "{{ default "52.3" (index .Values $aafRoot "cadi_longitude") }}"
    - name: cadi_latitude
      value: "{{ default "13.2" (index .Values $aafRoot "cadi_latitude") }}"
  #Hello specific.  Clients don't don't need this, unless Registering with AAF Locator
    - name: aaf_locator_public_fqdn
      value: "{{ (index .Values $aafRoot "public_fqdn") | default "" }}"
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
{{- $dot := default . .dot -}}
{{- $aafRoot := default "aafConfig" .aafRoot -}}
- name: {{ include "common.fullname" . }}-aaf-config-vol
  persistentVolumeClaim:
    claimName: {{ include "common.fullname" . }}-aaf-config-pvc
{{- if (index .Values $aafRoot "addconfig") }}
- name: aaf-add-config
  configMap:
    name: {{ include "common.fullname" . }}-aaf-add-config
    defaultMode: 0700
{{- end }}
{{- end -}}
{{- end }}

{{- define "common.aaf-config-pv" -}}
{{- $dot := default . .dot -}}
{{- $aafRoot := default "aafConfig" .aafRoot -}}
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
    storage: {{ index .Values $aafRoot  "persistence" "config" "size"}}
  accessModes:
    - {{ index .Values $aafRoot "persistence" "config" "accessMode" }}
  persistentVolumeReclaimPolicy: {{ index .Values $aafRoot "persistence" "config" "volumeReclaimPolicy" }}
  hostPath:
     path: {{ index .Values $aafRoot "persistence" "config" "mountPath" }}/{{ .Release.Name }}/{{ index .Values $aafRoot "persistence" "config" "mountSubPath" }}
{{- if (index .Values $aafRoot "persistence" "config" "storageClass") }}
{{- if (eq "-" (index .Values $aafRoot "persistence" "config" "storageClass")) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ index .Values $aafRoot "persistence" "config" "storageClass" }}"
{{- end }}
{{- end }}
{{- end -}}

{{- define "common.aaf-config-pvc" -}}
{{- $dot := default . .dot -}}
{{- $aafRoot := default "aafConfig" .aafRoot -}}
metadata:
  name: {{ include "common.fullname" . }}-aaf-config-pvc
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
    release: "{{ .Release.Name }}"
    heritage: "{{ .Release.Service }}"
{{- if (index .Values $aafRoot "persistence" "annotations") }}
  annotations:
{{ toYaml (index .Values $aafRoot "persistence" "annotations" ) | indent 4 }}
{{- end }}
spec:
  selector:
    matchLabels:
      app: {{ include "common.name" . }}-aaf-config-pv
  accessModes:
    - {{ index .Values $aafRoot "persistence" "config" "accessMode" }}
  resources:
    requests:
      storage: {{ index .Values $aafRoot "persistence" "config" "size" }}
{{- if (index .Values $aafRoot "persistence" "config" "storageClass") }}
{{- if (eq "-" (index .Values $aafRoot "persistence" "config" "storageClass")) }}
  storageClassName: ""
{{- else }}
  storageClassName: "{{ index .Values $aafRoot "persistence" "config" "storageClass" }}"
{{- end }}
{{- end }}
{{- end -}}
