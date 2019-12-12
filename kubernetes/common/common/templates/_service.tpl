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

{{/* Define the metadata of Service
     The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
     - .postfix : a string which will be added at the end of the name (with a
       '-'). If set to "NONE", it won't be printed (interesting for headless
       services).
     - .annotations: the annotations to add
     Usage example:
      {{ include "common.serviceMetadata" ( dict "postfix" "myService" "dot" .) }}
      {{ include "common.serviceMetadata" ( dict "annotations" .Values.service.annotation "dot" .) }}
*/}}
{{- define "common.serviceMetadata" -}}
  {{- $dot := default . .dot -}}
  {{- $postfix := default "" .postfix -}}
  {{- $annotations := default "" .annotations -}}
{{- if $annotations -}}
annotations: {{- include "common.tplValue" (dict "value" $annotations "context" $dot) | nindent 2 }}
{{- end }}
name: {{ include "common.servicename" $dot }}{{ if and $postfix (ne "NONE" $postfix) }}{{ print "-" $postfix }}{{ end }}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" $dot | nindent 2 -}}
{{- end -}}
{{/* Define the ports of Service
     The function takes three arguments (inside a dictionary):
     - .dot : environment (.)
     - .ports : an array of ports
     - .portType: the type of the service
*/}}
{{- define "common.servicePorts" -}}
{{- $portType := .portType -}}
{{- $dot := .dot -}}
{{- range $index, $port := .ports }}
- port: {{ $port.port }}
  targetPort: {{ $port.name }}
  {{- if (eq $portType "NodePort") }}
  nodePort: {{ $dot.Values.global.nodePortPrefix | default $dot.Values.nodePortPrefix }}{{ $port.nodePort }}
  {{- end }}
  name: {{ $port.name }}
{{- end -}}
{{- end -}}
{{/* Create service template */}}
{{- define "common.service" -}}
{{- $postfix := default "" .Values.service.postfix -}}
{{- $annotations := default "" .Values.service.annotations -}}
apiVersion: v1
kind: Service
metadata: {{ include "common.serviceMetadata" (dict "postfix" $postfix "annotations" $annotations "dot" . ) | nindent 2 }}
spec:
  ports: {{- include "common.servicePorts" (dict "portType" .Values.service.type "ports" .Values.service.ports "dot" .) | nindent 4 }}
  type: {{ .Values.service.type }}
  selector: {{- include "common.matchLabels" . | nindent 4 }}
{{- end -}}

{{/* Create headless service template */}}
{{- define "common.headlessService" -}}
{{- $postfix := default "headless" .Values.service.headless.postfix -}}
{{- $annotations := default "" .Values.service.headless.annotations -}}
apiVersion: v1
kind: Service
metadata: {{ include "common.serviceMetadata" (dict "postfix" $postfix "annotations" $annotations "dot" . ) | nindent 2 }}
spec:
  clusterIP: None
  ports: {{- include "common.servicePorts" (dict "portType" "ClusterIP" "ports" .Values.service.headlessPorts "dot" .) | nindent 4 }}
  {{- if .Values.service.headless.publishNotReadyAddresses }}
  publishNotReadyAddresses: {{ .Values.service.headless.publishNotReadyAddresses }}
  {{- end }}
  selector: {{- include "common.matchLabels" . | nindent 4 }}
  type: ClusterIP
{{- end -}}
