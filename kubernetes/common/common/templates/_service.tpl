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
  {{- $dot := default . .dot -}}
  {{- $name := default $dot.Chart.Name $dot.Values.nameOverride -}}
  {{- default $name $dot.Values.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define the metadata of Service
     The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : a string which will be added at the end of the name (with a '-').
     - .annotations: the annotations to add
     - .labels : labels to add
     Usage example:
      {{ include "common.serviceMetadata" ( dict "suffix" "myService" "dot" .) }}
      {{ include "common.serviceMetadata" ( dict "annotations" .Values.service.annotation "dot" .) }}
*/}}
{{- define "common.serviceMetadata" -}}
  {{- $dot := default . .dot -}}
  {{- $suffix := default "" .suffix -}}
  {{- $annotations := default "" .annotations -}}
  {{- $labels := default (dict) .labels -}}
{{- if $annotations -}}
annotations: {{- include "common.tplValue" (dict "value" $annotations "context" $dot) | nindent 2 }}
{{- end }}
name: {{ include "common.servicename" $dot }}{{ if $suffix }}{{ print "-" $suffix }}{{ end }}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" (dict "labels" $labels "dot" $dot) | nindent 2 -}}
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

{{/* Create generic service template
     The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .ports : an array of ports
     - .portType: the type of the service
     - .suffix : a string which will be added at the end of the name (with a '-')
     - .annotations: the annotations to add
     - .publishNotReadyAddresses: if we publish not ready address
     - .headless: if the service is headless
     - .labels : labels to add (dict)
     - .matchLabels: selectors/matachlLabels to add (dict)
*/}}
{{- define "common.genericService" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "" .suffix -}}
{{- $annotations := default "" .annotations -}}
{{- $publishNotReadyAddresses := default false .publishNotReadyAddresses -}}
{{- $portType := .portType -}}
{{- $ports := .ports -}}
{{- $headless := default false .headless -}}
{{- $labels := default (dict) .labels -}}
{{- $matchLabels := default (dict) .matchLabels -}}

apiVersion: v1
kind: Service
metadata: {{ include "common.serviceMetadata" (dict "suffix" $suffix "annotations" $annotations "labels" $labels "dot" $dot ) | nindent 2 }}
spec:
  {{- if $headless }}
  clusterIP: None
  {{- end }}
  ports: {{- include "common.servicePorts" (dict "portType" $portType "ports" $ports "dot" $dot) | nindent 4 }}
  {{- if $publishNotReadyAddresses }}
  publishNotReadyAddresses: true
  {{- end }}
  type: {{ $portType }}
  selector: {{- include "common.matchLabels" (dict "matchLabels" $matchLabels "dot" $dot) | nindent 4 }}
{{- end -}}

{{/* Create service template */}}
{{- define "common.service" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "" $dot.Values.service.suffix -}}
{{- $annotations := default "" $dot.Values.service.annotations -}}
{{- $publishNotReadyAddresses := default false $dot.Values.service.publishNotReadyAddresses -}}
{{- $portType := $dot.Values.service.type -}}
{{- $ports := $dot.Values.service.ports -}}
{{- $labels := default (dict) .labels -}}
{{- $matchLabels := default (dict) .matchLabels -}}
{{ include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" $dot "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "portType" $portType "labels" $labels "matchLabels" $matchLabels) }}
{{- end -}}

{{/* Create headless service template */}}
{{- define "common.headlessService" -}}
{{- $dot := default . .dot -}}
{{- $suffix := include "common._makeHeadlessSuffix" $dot -}}
{{- $annotations := default "" $dot.Values.service.headless.annotations -}}
{{- $publishNotReadyAddresses := default false $dot.Values.service.headless.publishNotReadyAddresses -}}
{{- $ports := $dot.Values.service.headlessPorts -}}
{{- $labels := default (dict) .labels -}}
{{- $matchLabels := default (dict) .matchLabels -}}
{{ include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" $dot "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "portType" "ClusterIP" "headless" true "labels" $labels "matchLabels" $matchLabels) }}
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
