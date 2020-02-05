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
  or call template with (dict "suffix" "mySuffix")
  unless either override mechanism is used.

  - .Values.global.persistence.storageClass  : override default storageClass for all charts
  - .Values.persistence.storageClassOverride : override global and default storage class on a per chart basis
  - .Values.persistence.storageClass         : override default storage class on a per chart basis

  In case of stuctures like this:
  - .Values.mySuffix.global.persistence.storageClass  : override default storageClass for all charts
  - .Values.mySuffix.persistence.storageClassOverride : override global and default storage class on a per chart basis
  - .Values.mySuffix.persistence.storageClass         : override default storage class on a per chart basis
 use:
   include "common.storageClass" (dict "suffix" "mySuffix" "pvValues" (index .Values "mySuffix") "dot" .)

*/}}
{{- define "common.storageClass" -}}
{{- $dot := default . .dot}}
{{- $pvValues := default (index $dot "Values") .pvValues -}}
{{- $suffix := default "data" .suffix}}
  {{- if $pvValues.persistence.storageClassOverride -}}
    {{- if ne "-" $pvValues.persistence.storageClassOverride -}}
      {{- printf "%s" $pvValues.persistence.storageClassOverride -}}
    {{- else -}}
      {{- $storage_class := "" -}}
      {{- printf "%q" $storage_class -}}
    {{- end -}}
  {{- else -}}
    {{- if or $pvValues.persistence.storageClass $dot.Values.global.persistence.storageClass }}
      {{- if ne "-" (default $pvValues.persistence.storageClass $dot.Values.global.persistence.storageClass) -}}
        {{- printf "%s" (default $pvValues.persistence.storageClass $dot.Values.global.persistence.storageClass) -}}
      {{- else -}}
        {{- $storage_class := "" -}}
        {{- printf "%q" $storage_class -}}
      {{- end -}}
    {{- else -}}
      {{- printf "%s-%s" (include "common.fullname" $dot) $suffix -}}
    {{- end -}}
  {{- end -}}
{{- end -}}

{{/*
  Calculate if we need a PV. If a storageClass is provided, then we don't need.
*/}}
{{- define "common.needPV" -}}
{{- $global := default . .dot}}
{{- $pvValues := default (index $global "Values") .pvValues -}}
{{- if not (or (or $pvValues.persistence.storageClassOverride $pvValues.persistence.storageClass) $global.Values.global.persistence.storageClass) -}}
  True
{{- end -}}
{{- end -}}

{{/*
  Generate N PV for a statefulset
*/}}
{{- define "common.replicaPV" -}}
{{- $global := default . .dot}}
{{- $suffix := default "data" .suffix}}
{{- $pvValues := default $global.Values .pvValues -}}
{{- if and $pvValues.persistence.enabled (not $pvValues.persistence.existingClaim) }}
{{- if (include "common.needPV" (dict "pvValues" $pvValues "dot" $global)) -}}
{{- range $i := until (int $pvValues.replicaCount)}}
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: {{ include "common.fullname" $global }}-{{$suffix}}-{{$i}}
  namespace: {{ include "common.namespace" $global }}
  labels: {{- include "common.labels" $global | nindent 4 }}
spec:
  capacity:
    storage: {{ $pvValues.persistence.size}}
  accessModes:
    - {{ $pvValues.persistence.accessMode }}
  persistentVolumeReclaimPolicy: {{ $pvValues.persistence.volumeReclaimPolicy }}
  storageClassName: "{{ include "common.fullname" $global }}-{{$suffix}}"
  hostPath:
    path: {{ $global.Values.global.persistence.mountPath | default $pvValues.persistence.mountPath }}/{{ include "common.fullname" $global }}/{{ $pvValues.persistence.mountSubPath }}-{{$i}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
