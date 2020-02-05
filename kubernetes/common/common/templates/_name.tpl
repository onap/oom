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
  Expand the name of a chart.
  The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
*/}}
{{- define "common.name" -}}
  {{- $dot := default . .dot -}}
  {{- default $dot.Chart.Name $dot.Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  The same as common.full name but based on passed dictionary instead of trying to figure
  out chart name on its own.
  The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
*/}}
{{- define "common.fullnameExplicit" -}}
  {{- $dot := .dot }}
  {{- $name := .chartName }}
  {{- printf "%s-%s" (include "common.release" $dot) $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Create a default fully qualified application name.
  Truncated at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
  The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : add a suffix to the fullname
*/}}
{{- define "common.fullname" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default (dict) .suffix -}}
  {{- $name := default $dot.Chart.Name $dot.Values.nameOverride -}}
  {{- include "common.fullnameExplicit" (dict "dot" $dot "chartName" $name) }}{{ if $suffix }}{{ print "-" $suffix }}{{ end }}
{{- end -}}

{{/*
  Retrieve the "original" release from the component release:
  if ONAP is deploy with "helm deploy --name toto", then cassandra components
  will have "toto-cassandra" as release name.
  this function would answer back "toto".
  The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
*/}}
{{- define "common.release" -}}
  {{- $dot := default . .dot -}}
  {{- first (regexSplit "-" $dot.Release.Name -1)  }}
{{- end -}}

{{- define "common.chart" -}}
{{- $dot := default . .dot -}}
{{- printf "%s-%s" $dot.Chart.Name $dot.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{- define "common.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}
