{{/*
# Copyright © 2017 Amdocs, Bell Canada
# Modifications Copyright © 2019 AT&T
# Copyright (c) 2021 J. F. Lucas.  All rights reserved.
# Copyright (c) 2021 Nordix Foundation.
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
dcaegen2-services-common.configMap:
This template produces Kubernetes configMap(s) needed by a
DCAE microservice.

The template expects the full chart context as input.  A chart for a
DCAE microservice references this template using:
{{ include "dcaegen2-services-common.configMap" . }}
The template directly references data in .Values, and indirectly (through its
use of templates from the ONAP "common" collection) references data in
.Release.

The template always produces a configMap containing the microservice's
initial configuration data.  This configMap is used by an initContainer
that loads the configuration into Consul.  (See the documentation for
dcaegen2-services-common.microserviceDeployment for more details.)

If the microservice is using a logging sidecar (again, see the documentation
for dcaegen2-services-common.microserviceDeployment for more details), the
template generates an additiona configMap that supplies configuration
information for the logging sidecar.
*/}}

{{- define "dcaegen2-services-common.configMap" -}}
{{- $appConf := .Values.applicationConfig | default (dict) -}}
apiVersion: v1
kind: ConfigMap
metadata:
    name: {{ include "common.fullname" . }}-application-config-configmap
    namespace: {{ include "common.namespace" . }}
    labels: {{ include "common.labels" . | nindent 6 }}
data:
  application_config.yaml: |
{{ $appConf | toYaml | indent 4 }}

{{- if .Values.drFeedConfig }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-feeds-config
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 6 }}
data:
  {{- range $i, $feed := .Values.drFeedConfig }}
  feedConfig-{{$i}}.json: |-
  {{ $feed | toJson | indent 2 }}
  {{- end }}
{{- end }}

{{- if .Values.drPubConfig }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-drpub-config
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 6 }}
data:
  {{- range $i, $drpub := .Values.drPubConfig }}
  drpubConfig-{{$i}}.json: |-
  {{ $drpub | toJson | indent 2 }}
  {{- end }}
{{- end }}

{{- if .Values.drSubConfig }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-drsub-config
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 6 }}
data:
  {{- range $i, $drsub := .Values.drSubConfig }}
  drsubConfig-{{$i}}.json: |-
  {{ $drsub | toJson | indent 2 }}
  {{- end }}
{{- end }}

{{- if .Values.mrTopicsConfig }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ include "common.fullname" . }}-topics-config
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 6 }}
data:
  {{- range $i, $topics := .Values.mrTopicsConfig }}
  topicsConfig-{{$i}}.json: |-
  {{ $topics | toJson | indent 2 }}
  {{- end }}
{{- end }}
{{- end }}
