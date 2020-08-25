{{/*
# Copyright © 2020 Orange
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
  Resolve the level of the logs.
  The value for .Values.logLevel is used by default,
  unless either override mechanism is used.

  - .Values.global.logLevel  : override default log level for all components
  - .Values.logLevelOverride : override global and default log level on a per
                               component basis

  The function can takes below arguments (inside a dictionary):
     - .dot : environment (.)
     - .initRoot : the root dictionary of logConfiguration submodule
                   (default to .Values.logConfiguration)
*/}}
{{- define "common.log.level" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.logConfiguration .initRoot -}}
{{/*  Our version of helm doesn't support deepCopy so we need this nasty trick */}}
{{-   $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
  {{- if $subchartDot.Values.logLevelOverride }}
    {{- printf "%s" $subchartDot.Values.logLevelOverride -}}
  {{- else }}
    {{- default $subchartDot.Values.logLevel $subchartDot.Values.global.logLevel -}}
  {{- end }}
{{- end -}}
