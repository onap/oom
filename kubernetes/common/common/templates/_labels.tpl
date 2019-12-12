{{/*
# Copyright © 2019 Orange
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
*/}}
{{- define "common.labels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
helm.sh/chart: {{ include "common.chart" . }}
app.kubernetes.io/instance: {{ include "common.release" . }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Labels to use on deploy.spec.selector.matchLabels and svc.spec.selector
*/}}
{{- define "common.matchLabels" -}}
app.kubernetes.io/name: {{ include "common.name" . }}
app.kubernetes.io/instance: {{ include "common.release" . }}
{{- end -}}

{{/*
  Generate "top" metadata for Deployment / StatefulSet / ...
*/}}
{{- define "common.resourceMetadata" -}}
name: {{ include "common.fullname" . }}
namespace: {{ include "common.namespace" . }}
labels: {{- include "common.labels" . | nindent 2 }}
{{- end -}}

{{/*
  Generate selectors for Deployment / StatefulSet / ...
*/}}
{{- define "common.selectors" -}}
matchLabels: {{- include "common.matchLabels" . | nindent 2 }}
{{- end -}}

{{/*
  Generate "template" metadata for Deployment / StatefulSet / ...
*/}}
{{- define "common.templateMetadata" -}}
{{- if .Values.podAnnotations }}
annotations: {{- include "common.tplValue" (dict "value" .Values.podAnnotations "context" $) | nindent 2 }}
{{- end }}
labels: {{- include "common.labels" . | nindent 2 }}
name: {{ include "common.name" . }}
{{- end -}}
