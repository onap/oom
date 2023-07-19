{{/*
# Copyright © 2019 Orange
# Modifications Copyright (C) 2022 Bell Canada
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
Common labels
The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .labels : labels to add (dict)
*/}}
{{- define "common.labels" -}}
{{- $dot := default . .dot -}}
app.kubernetes.io/name: {{ include "common.name" $dot }}
app: {{ include "common.name" $dot }}
{{- if $dot.Chart.AppVersion }}
version: "{{ $dot.Chart.AppVersion | replace "+" "_" }}"
{{- else }}
version: "{{ $dot.Chart.Version | replace "+" "_" }}"
{{- end }}
{{ if not .ignoreHelmChart }}
helm.sh/chart: {{ include "common.chart" $dot }}
{{- end }}
app.kubernetes.io/instance: {{ include "common.release" $dot }}
app.kubernetes.io/managed-by: {{ $dot.Release.Service }}
{{ if .labels }}
{{- include "common.tplValue" (dict "value" .labels "context" $dot) }}
{{- end }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .matchLabels: selectors/matchlLabels to add (dict)
*/}}
{{- define "common.matchLabels" -}}
{{- $dot := default . .dot -}}
{{- $matchLabels := default (dict) .matchLabels -}}
{{- if not $matchLabels.nameNoMatch -}}
app.kubernetes.io/name: {{ include "common.name" $dot }}
{{- end }}
app.kubernetes.io/instance: {{ include "common.release" $dot }}
{{- if $matchLabels }}
{{$_ := unset $matchLabels "nameNoMatch"}}
{{- include "common.tplValue" (dict "value" $matchLabels "context" $dot) }}
{{- end }}
{{- end -}}

{{/*
  Generate "top" metadata for Deployment / StatefulSet / ...
  The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .labels: labels to add (dict)
     - .suffix: suffix to name

*/}}
{{- define "common.resourceMetadata" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "" .suffix -}}
{{- $labels := default (dict) .labels -}}
{{- $annotations := default (dict) .annotations -}}
name: {{ include "common.fullname" (dict "suffix" $suffix "dot" $dot )}}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" (dict "labels" $labels "ignoreHelmChart" .ignoreHelmChart "dot" $dot ) | nindent 2 }}
{{- if $annotations }}
annotations:  {{- include "common.tplValue" (dict "value" $annotations "context" $dot) | nindent 2}}
{{- end }}
{{- end -}}

{{/*
  Generate selectors for Deployment / StatefulSet / ...
    The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .matchLabels: labels to add (dict)
*/}}
{{- define "common.selectors" -}}
{{- $dot := default . .dot -}}
{{- $matchLabels := default (dict) .matchLabels -}}
matchLabels: {{- include "common.matchLabels" (dict "matchLabels" $matchLabels "dot" $dot) | nindent 2 }}
{{- end -}}

{{/*
  Generate "template" metadata for Deployment / StatefulSet / ...
    The function takes several arguments (inside a dictionary)
     - .dot : environment (.)
     - .labels: labels to add (dict)
*/}}
{{- define "common.templateMetadata" -}}
{{- $dot := default . .dot -}}
{{- $labels := default (dict) .labels -}}
{{- if $dot.Values.podAnnotations }}
annotations: {{- include "common.tplValue" (dict "value" $dot.Values.podAnnotations "context" $dot) | nindent 2 }}
{{- end }}
labels: {{- include "common.labels" (dict "labels" $labels "ignoreHelmChart" .ignoreHelmChart "dot" $dot) | nindent 2 }}
name: {{ include "common.name" $dot }}
{{- end -}}
