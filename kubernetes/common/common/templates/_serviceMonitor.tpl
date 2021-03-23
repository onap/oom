{{/*
# Copyright © 2021 Bell Canada
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
  Resolve the name of a chart's serviceMonitor.

  The default will be the chart name (or .Values.nameOverride if set).
  And the use of .Values.serviceMonitor.name overrides all.

  - .Values.serviceMonitor.name: override default serviceMonitor (ie. chart) name
  Example values file addition:

  serviceMonitor:
    targetPort: 8080
    path: /metrics
    basicAuth:
      enabled: false
      # externalSecretName: mysecretname
      # externalSecretUserKey: myusernamekey
      # externalSecretPasswordKey: mypasswoordkey


*/}}
{{/*
  Expand the serviceMonitor name for a chart.
*/}}
{{- define "common.serviceMonitorName" -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- default $name .Values.serviceMonitor.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define the metadata of serviceMonitor
     The function takes from one to four arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : a string which will be added at the end of the name (with a '-').
     - .annotations: the annotations to add
     - .labels : labels to add
     Usage example:
      {{ include "common.serviceMonitorMetadata" ( dict "suffix" "myService" "dot" .) }}
      {{ include "common.serviceMonitorMetadata" ( dict "annotations" .Values.serviceMonitor.annotation "dot" .) }}
*/}}

{{- define "common.serviceMonitorMetadata" -}}
  {{- $dot := default . .dot -}}
  {{- $annotations := default "" .annotations -}}
  {{- $labels := default (dict) .labels -}}
{{- if $annotations -}}
annotations:
{{      include "common.tplValue" (dict "value" $annotations "context" $dot) | indent 2 }}
{{- end }}
name: {{ include "common.serviceMonitorName" $dot }}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" (dict "labels" $labels "dot" $dot) | nindent 2 }}
{{- end -}}

{{/*
    Create service monitor template
*/}}
{{- define "common.serviceMonitor" -}}
{{-   $dot := default . .dot -}}
{{-   $annotations := default "" $dot.Values.service.annotations -}}
{{-   $targetPort := $dot.Values.serviceMonitor.targetPort -}}
{{-   $path := $dot.Values.serviceMonitor.path }}
{{-   $labels := default (dict) .labels -}}
{{-   $basicAuthEnabled := $dot.Values.serviceMonitor.basicAuth.enabled }}
{{-   $externalSecretName := $dot.Values.serviceMonitor.basicAuth.externalSecretName }}
{{-   $externalSecretUserKey := $dot.Values.serviceMonitor.basicAuth.externalSecretUserKey }}
{{-   $externalSecretPasswordKey := $dot.Values.serviceMonitor.basicAuth.externalSecretPasswordKey }}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
{{- include "common.serviceMonitorMetadata" $dot }}
spec:
  endpoints:
  - path: {{ default "/metrics" $path }} 
    targetPort: {{ $targetPort }}
    {{- if $basicAuthEnabled }}
    basicAuth:
      username:
        key: {{ $externalSecretUserKey }}
        name: {{ $externalSecretName }}
      password:
        key: {{ $externalSecretPasswordKey }}
        name: {{ $externalSecretName }}
    {{- end }}
  namespaceSelector:
    matchNames:
    - {{ include "common.namespace" $dot }}
  selector:
    matchLabels: {{- include "common.labels" (dict "labels" $labels "dot" $dot) | nindent 6 }}
{{- end -}}
