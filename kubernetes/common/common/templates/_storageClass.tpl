{{/*
# Copyright © 2019 Amdocs, Bell Canada, Orange
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
  Expand the name of the storage class.
  The value "common.fullname"-data is used by default,
  unless either override mechanism is used.

  - .Values.global.persistence.storageClass  : override default storageClass for all charts
  - .Values.persistence.storageClassOverride : override global and default storage class on a per chart basis
  - .Values.persistence.storageClass         : override default storage class on a per chart basis
*/}}
{{- define "common.storageClass" -}}
  {{- if .Values.persistence.storageClassOverride -}}
    {{- if ne "-" .Values.persistence.storageClassOverride -}}
      {{- printf "%s" .Values.persistence.storageClassOverride -}}
    {{- else -}}
      {{- $storage_class := "" -}}
      {{- printf "%q" $storage_class -}}
    {{- end -}}
  {{- else -}}
    {{- if or .Values.persistence.storageClass .Values.global.persistence.storageClass }}
      {{- if ne "-" (default .Values.persistence.storageClass .Values.global.persistence.storageClass) -}}
        {{- printf "%s" (default .Values.persistence.storageClass .Values.global.persistence.storageClass) -}}
      {{- else -}}
        {{- $storage_class := "" -}}
        {{- printf "%q" $storage_class -}}
      {{- end -}}
    {{- else -}}
      {{- printf "%s-data" (include "common.fullname" .) -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
  Calculate if we need a PV. If a storageClass is provided, then we don't need.
*/}}
{{- define "common.needPV" -}}
{{- if or (or .Values.persistence.storageClassOverride .Values.persistence.storageClass) .Values.global.persistence.storageClass -}}
  False
{{- else -}}
  True
{{- end -}}
{{- end -}}
