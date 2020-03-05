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
{{- if not (or (or .Values.persistence.storageClassOverride .Values.persistence.storageClass) .Values.global.persistence.storageClass) -}}
  True
{{- end -}}
{{- end -}}

{{/*
  Generate a PV
*/}}
{{- define "common.PV" -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) -}}
{{- if eq "True" (include "common.needPV" .) -}}
kind: PersistentVolume
apiVersion: v1
metadata:
  name: {{ include "common.fullname" . }}-data
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}"
    release: "{{ include "common.release" . }}"
    heritage: "{{ .Release.Service }}"
    name: {{ include "common.fullname" . }}
spec:
  capacity:
    storage: {{ .Values.persistence.size}}
  accessModes:
    - {{ .Values.persistence.accessMode }}
  storageClassName: "{{ include "common.fullname" . }}-data"
  persistentVolumeReclaimPolicy: {{ .Values.persistence.volumeReclaimPolicy }}
  hostPath:
    path: {{ .Values.global.persistence.mountPath | default .Values.persistence.mountPath }}/{{ include "common.release" . }}/{{ .Values.persistence.mountSubPath }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
  Generate N PV for a statefulset
*/}}
{{- define "common.replicaPV" -}}
{{- $global := . }}
{{- if and $global.Values.persistence.enabled (not $global.Values.persistence.existingClaim) }}
{{- if (include "common.needPV" .) -}}
{{- range $i := until (int $global.Values.replicaCount)}}
---
kind: PersistentVolume
apiVersion: v1
metadata:
  name: {{ include "common.fullname" $global }}-data-{{$i}}
  namespace: {{ include "common.namespace" $global }}
  labels: {{- include "common.labels" $global | nindent 4 }}
spec:
  capacity:
    storage: {{ $global.Values.persistence.size}}
  accessModes:
    - {{ $global.Values.persistence.accessMode }}
  persistentVolumeReclaimPolicy: {{ $global.Values.persistence.volumeReclaimPolicy }}
  storageClassName: "{{ include "common.fullname" $global }}-data"
  hostPath:
    path: {{ $global.Values.global.persistence.mountPath | default $global.Values.persistence.mountPath }}/{{ include "common.release" $global }}/{{ $global.Values.persistence.mountSubPath }}-{{$i}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
  Generate a PVC
*/}}
{{- define "common.PVC" -}}
{{- if and .Values.persistence.enabled (not .Values.persistence.existingClaim) -}}
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: {{ include "common.fullname" . }}
  namespace: {{ include "common.namespace" . }}
  labels:
    app: {{ include "common.name" . }}
    chart: "{{ .Chart.Name }}-{{ .Chart.Version }}"
    release: "{{ include "common.release" . }}"
    heritage: "{{ .Release.Service }}"
{{- if .Values.persistence.annotations }}
  annotations:
{{ toYaml .Values.persistence.annotations | indent 4 }}
{{- end }}
spec:
  accessModes:
    - {{ .Values.persistence.accessMode }}
  storageClassName: {{ include "common.storageClass" . }}
  resources:
    requests:
      storage: {{ .Values.persistence.size }}
{{- end -}}
{{- end -}}
