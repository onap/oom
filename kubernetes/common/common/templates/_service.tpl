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

  - .Values.service.name: override default service (ie. chart) name
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
     - .suffix : a string which will be added at the end of the name (with a '-').
     - .annotations: the annotations to add
     Usage example:
      {{ include "common.serviceMetadata" ( dict "suffix" "myService" "dot" .) }}
      {{ include "common.serviceMetadata" ( dict "annotations" .Values.service.annotation "dot" .) }}
*/}}
{{- define "common.serviceMetadata" -}}
  {{- $dot := default . .dot -}}
  {{- $suffix := default "" .suffix -}}
  {{- $annotations := default "" .annotations -}}
{{- if $annotations -}}
annotations: {{- include "common.tplValue" (dict "value" $annotations "context" $dot) | nindent 2 }}
{{- end }}
name: {{ include "common.servicename" $dot }}{{ if $suffix }}{{ print "-" $suffix }}{{ end }}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" $dot | nindent 2 -}}
{{- end -}}

{{/* Define the ports of Service
     The function takes three arguments (inside a dictionary):
     - .dot : environment (.)
     - .ports : an array of ports
     - .serviceType: the type of the service
*/}}
{{- define "common.servicePorts" -}}
{{- $serviceType := .serviceType }}
{{- $dot := .dot }}
{{-   range $index, $port := .ports }}
{{-     if (include "common.needTLS" $dot) }}
- port: {{ $port.port }}
  targetPort: {{ $port.name }}
{{-       if $port.port_protocol }}
  name: {{ printf "%ss-%s" $port.port_protocol $port.name }}
{{-       else }}
  name: {{ $port.name }}
{{-       end }}
{{-       if (eq $serviceType "NodePort") }}
  nodePort: {{ $dot.Values.global.nodePortPrefix | default $dot.Values.nodePortPrefix }}{{ $port.nodePort }}
{{-       end }}
{{-     else }}
- port: {{ default $port.port $port.plain_port }}
  targetPort: {{ $port.name }}
{{-       if $port.port_protocol }}
  name: {{ printf "%s-%s" $port.port_protocol $port.name }}
{{-       else }}
  name: {{ $port.name }}
{{-       end }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/* Create generic service template
     The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .ports : an array of ports
     - .serviceType: the type of the service
     - .suffix : a string which will be added at the end of the name (with a '-')
     - .annotations: the annotations to add
     - .publishNotReadyAddresses: if we publish not ready address
     - .headless: if the service is headless
*/}}
{{- define "common.genericService" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "" .suffix -}}
{{- $annotations := default "" .annotations -}}
{{- $publishNotReadyAddresses := default false .publishNotReadyAddresses -}}
{{- $serviceType := .serviceType -}}
{{- $ports := .ports -}}
{{- $headless := default false .headless -}}
apiVersion: v1
kind: Service
metadata: {{ include "common.serviceMetadata" (dict "suffix" $suffix "annotations" $annotations "dot" $dot ) | nindent 2 }}
spec:
  {{- if $headless }}
  clusterIP: None
  {{- end }}
  ports: {{- include "common.servicePorts" (dict "serviceType" $serviceType "ports" $ports "dot" $dot) | nindent 4 }}
  {{- if $publishNotReadyAddresses }}
  publishNotReadyAddresses: true
  {{- end }}
  {{- if (include "common.needTLS" $dot) }}
  type: {{ $serviceType }}
  {{- else }}
  type: ClusterIP
  {{- end }}
  selector: {{- include "common.matchLabels" $dot | nindent 4 }}
{{- end -}}

{{/* Create service template */}}
{{- define "common.service" -}}
{{- $suffix := default "" .Values.service.suffix -}}
{{- $annotations := default "" .Values.service.annotations -}}
{{- $publishNotReadyAddresses := default false .Values.service.publishNotReadyAddresses -}}
{{- $serviceType := .Values.service.type -}}
{{- $ports := .Values.service.ports -}}
{{ include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" . "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" $serviceType) }}
{{- end -}}

{{/* Create headless service template */}}
{{- define "common.headlessService" -}}
{{- $suffix := include "common._makeHeadlessSuffix" . -}}
{{- $annotations := default "" .Values.service.headless.annotations -}}
{{- $publishNotReadyAddresses := default false .Values.service.headless.publishNotReadyAddresses -}}
{{- $ports := .Values.service.headlessPorts -}}
{{ include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" . "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" "ClusterIP" "headless" true ) }}
{{- end -}}

{{/*
  Generate the right suffix for headless service
*/}}
{{- define "common._makeHeadlessSuffix" -}}
{{-   if hasKey .Values.service.headless "suffix" }}
{{-     .Values.service.headless.suffix }}
{{-   else }}
{{-     print "headless" }}
{{-   end }}
{{- end -}}
