{{/*
# Copyright © 2017 Amdocs, Bell Canada
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
  Resolve the name of a chart's service.

  The default will be the chart name (or .Values.nameOverride if set).
  And the use of .Values.service.name overrides all.

  - .Values.service.name  : override default service (ie. chart) name
*/}}
{{/*
  Expand the service name for a chart.
*/}}
{{- define "common.servicename" -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- default $name .Values.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.service" -}}
---
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.servicename" . }}
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  type: {{ .Values.service.type }}
  ports:
  {{- if eq .Values.service.type "NodePort" -}}
  {{- if .Values.global.installSidecarSecurity }}
  - port: {{ .Values.global.rproxy.port }}
  {{- else }}
  - port: {{ .Values.service.internalPort }}
  {{- end }}
    {{- if lt ( .Values.service.nodePort | int ) 10 }}
    nodePort: {{ .Values.global.nodePortPrefix | default .Values.nodePortPrefix | int }}0{{ .Values.service.nodePort }}
    {{- else }}
    nodePort: {{ .Values.global.nodePortPrefix | default .Values.nodePortPrefix | int }}{{ .Values.service.nodePort }}
    {{- end }}
    name: {{ .Values.service.portName }}
    {{- if .Values.service.nodePort2 }}
  - port: {{ .Values.service.internalPort2 }}
    {{- if lt ( .Values.service.nodePort2 | int ) 10 }}
    nodePort: {{ .Values.global.nodePortPrefix | default .Values.nodePortPrefix | int }}0{{ .Values.service.nodePort2 }}
    {{- else }}
    nodePort: {{ .Values.global.nodePortPrefix | default .Values.nodePortPrefix | int }}{{ .Values.service.nodePort2 }}
    {{- end }}
    name: {{ .Values.service.portName2 }}
    {{- end }}
  {{- else }}
  {{- if .Values.global.installSidecarSecurity }}
  - port: {{ .Values.global.rproxy.port }}
  {{- else }}
  - port: {{ .Values.service.internalPort }}
  {{- end }}
    name: {{ .Values.service.portName }}
    {{- if .Values.service.internalPort2 }}
  - port: {{ .Values.service.internalPort2 }}
    name: {{ .Values.service.portName2 }}
    {{- end }}
  clusterIP: None
  {{- end}}
  selector:
    app: {{ include "common.name" . }}
    release: {{ .Release.Name }}
{{- end -}}
