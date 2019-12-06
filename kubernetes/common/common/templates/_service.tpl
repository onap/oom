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

{{/* Create service template */}}
{{- define "common.service" -}}
apiVersion: v1
kind: Service
metadata:
  {{- if .Values.service.annotations }}
  annotations: {{ include "common.tplValue" (dict "value" .Values.service.annotations "context" $) | nindent 4 }}
  {{- end }}
  name: {{ include "common.servicename" . }}
  namespace: {{ include "common.namespace" . }}
  labels: {{- include "common.labels" . | nindent 4 }}
spec:
  ports:
{{- if eq .Values.service.type "NodePort" }}
  {{- $global := . }}
  {{- range $index, $ports := .Values.service.ports }}
  - port: {{ $ports.internalPort }}
    targetPort: {{ $ports.externalPort }}
    nodePort: {{ $global.Values.global.nodePortPrefix | default $global.Values.nodePortPrefix }}{{ $ports.nodePort }}
    name: {{ $ports.name }}
  {{- end }}
{{- else }}
  {{- range $index, $ports := .Values.service.ports }}
  - port: {{ $ports.internalPort }}
    targetPort: {{ $ports.externalPort }}
    name: {{ $ports.name }}
  {{- end }}
{{- end }}
  type: {{ .Values.service.type }}
  selector: {{- include "common.matchLabels" . | nindent 4 }}
{{- end -}}

{{/* Create headless service template */}}
{{- define "common.headlessService" -}}
apiVersion: v1
kind: Service
metadata:
  {{- if .Values.service.annotations }}
  annotations: {{ include "common.tplValue" (dict "value" .Values.service.headless.annotations "context" $) | nindent 4 }}
  {{- end }}
  name: {{ include "common.servicename" . }}-headless
  namespace: {{ include "common.namespace" . }}
  labels: {{- include "common.labels" . | nindent 4 }}
spec:
  ports:
  {{- range $index, $ports := .Values.service.headlessPorts }}
  - port: {{ $ports.internalPort }}
    targetPort: {{ $ports.externalPort }}
    name: {{ $ports.name }}
  {{- end }}
  selector: {{- include "common.matchLabels" . | nindent 4 }}
  type: ClusterIP
  clusterIP: None
{{- end -}}
