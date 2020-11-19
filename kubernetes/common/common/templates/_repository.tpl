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
  /!\ DEPRECATED /!\
  Will be removed when transition to "repositoryGenerator" is finished.
  Resolve the name of the common image repository.
  The value for .Values.repository is used by default,
  unless either override mechanism is used.

  - .Values.global.repository  : override default image repository for all images
  - .Values.repositoryOverride : override global and default image repository on a per image basis
*/}}
{{- define "common.repository" -}}
  {{if .Values.repositoryOverride }}
    {{- printf "%s" .Values.repositoryOverride -}}
  {{else}}
    {{- default .Values.repository .Values.global.repository -}}
  {{end}}
{{- end -}}
