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
  Give the root folder for ONAP when using host pathes

  The function takes up to two arguments (inside a dictionary):
    - .dot : environment (.)
    - .subPath: the sub path to use, default to
                ".Values.persistence.mountSubPath"

  Example calls:
    {{ include "common.storageClass" . }}
    {{ include "common.storageClass" (dict "dot" . "subPath" "my-awesome-subPath") }}
*/}}
{{- define "common.persistencePath" -}}
{{-   $dot := default . .dot -}}
{{-   $subPath := default $dot.Values.persistence.mountSubPath .subPath -}}
{{ $dot.Values.global.persistence.mountPath | default $dot.Values.persistence.mountPath }}/{{ include "common.release" $dot }}/{{ $subPath }}
{{- end -}}

{{/*
  Expand the name of the storage class.
  The value "common.fullname"-data is used by default,
  unless either override mechanism is used.

  - .Values.global.persistence.storageClass  : override default storageClass for
                                               all charts
  - .Values.persistence.storageClassOverride : override global and default
                                               storage class on a per chart
                                               basis
  - .Values.persistence.storageClass         : override default storage class on
                                               per chart basis

  The function takes up to two arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix: suffix to name. if not set, default to "data" when no override
        mechanism is used.
     - .persistenceInfos: the persitence values to use, default to
                          "persistence".
                          Need to be the path from `.Values` in string format.
                          let's say you have:

                              persistence:
                                logs:
                                  enabled: true
                                  size: 100Mi
                                  accessMode: ReadWriteOnce
                                  ...

                          then you have to put "persitence.logs" in order to use
                          it.


  Example calls:
    {{ include "common.storageClass" . }}
    {{ include "common.storageClass" (dict "dot" . "suffix" "my-awesome-suffix") }}
    {{ include "common.storageClass" (dict "dot" . "suffix" "my-awesome-suffix" "persistenceInfos" .Values.persistenceLog) }}
*/}}
{{- define "common.storageClass" -}}
{{-   $dot := default . .dot -}}
{{-   $suffix := default "data" .suffix -}}
{{-   $persistenceInfosLabel := default "persistence" .persistenceInfos -}}
{{-   $persistenceInfos := index $dot "Values" }}
{{-   range $key := regexSplit "[.]" $persistenceInfosLabel -1 -}}
{{-     $persistenceInfos = index $persistenceInfos $key -}}
{{-   end -}}
  {{- if (index $persistenceInfos "storageClassOverride") -}}
    {{- if ne "-" (index $persistenceInfos "storageClassOverride") -}}
      {{- printf "%s" (index $persistenceInfos "storageClassOverride") -}}
    {{- else -}}
      {{- $storage_class := "" -}}
      {{- printf "%q" $storage_class -}}
    {{- end -}}
  {{- else -}}
    {{- if or (index $persistenceInfos "storageClass") $dot.Values.global.persistence.storageClass }}
      {{- if ne "-" (default (index $persistenceInfos "storageClass") $dot.Values.global.persistence.storageClass) -}}
        {{- printf "%s" (default (index $persistenceInfos "storageClass") $dot.Values.global.persistence.storageClass) -}}
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
{{- if not (or (or .Values.persistence.storageClassOverride .Values.persistence.storageClass) .Values.global.persistence.storageClass) -}}
  True
{{- end -}}
{{- end -}}

{{/*
  Generate a PV

  The function takes up to three arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix: suffix to name. if not set, default to "data".
     - .persistenceInfos: the persitence values to use, default to
                          "persistence".
                          Need to be the path from `.Values` in string format.
                          let's say you have:

                              persistence:
                                logs:
                                  enabled: true
                                  size: 100Mi
                                  accessMode: ReadWriteOnce
                                  ...

                          then you have to put "persitence.logs" in order to use
                          it.

  Example calls:
    {{ include "common.PV" . }}
    {{ include "common.PV" (dict "dot" . "suffix" "my-awesome-suffix" "persistenceInfos" "persistenceLog" ) }}
    {{ include "common.PV" (dict dot" . "subPath" "persistenceInfos" "persistence.log") }}
*/}}
{{- define "common.PV" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "data" .suffix -}}
{{- $persistenceInfosLabel := default "persistence" .persistenceInfos -}}
{{- $persistenceInfos := index $dot "Values" }}
{{- range $key := regexSplit "[.]" $persistenceInfosLabel -1 -}}
{{- $persistenceInfos = index $persistenceInfos $key -}}
{{- end -}}
{{- $labels := index $persistenceInfos "labels" }}
{{- if and (index $persistenceInfos "enabled") (not (index $persistenceInfos "existingClaim")) -}}
{{- if (include "common.needPV" $dot) -}}
kind: PersistentVolume
apiVersion: v1
metadata: {{- include "common.resourceMetadata" (dict "dot" $dot "suffix" $suffix "labels" $labels) | nindent 2 }}
spec:
  capacity:
    storage: {{ index $persistenceInfos "size" }}
  accessModes:
    - {{ index $persistenceInfos "accessMode" }}
  persistentVolumeReclaimPolicy: {{ index $persistenceInfos "volumeReclaimPolicy" }}
  storageClassName: "{{ include "common.fullname" $dot }}-{{ $suffix }}"
  hostPath:
    path: {{ include "common.persistencePath"  (dict "dot" $dot "subPath" (index $persistenceInfos "mountSubPath")) }}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
  Generate N PV for a statefulset

  The function takes up to two arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix: suffix to name. if not set, default to "data".
     - .persistenceInfos: the persitence values to use, default to
                          "persistence".
                          Need to be the path from `.Values` in string format.
                          let's say you have:

                              persistence:
                                logs:
                                  enabled: true
                                  size: 100Mi
                                  accessMode: ReadWriteOnce
                                  ...

                          then you have to put "persitence.logs" in order to use
                          it.

  Example calls:
    {{ include "common.replicaPV" . }}
    {{ include "common.replicaPV" (dict "dot" . "suffix" "my-awesome-suffix" "persistenceInfos" .Values.persistenceLog) }}
    {{ include "common.replicaPV" (dict dot" . "subPath" "persistenceInfos" .Values.persistence.log) }}
*/}}
{{- define "common.replicaPV" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "data" .suffix -}}
{{- $persistenceInfosLabel := default "persistence" .persistenceInfos -}}
{{- $persistenceInfos := index $dot "Values" }}
{{- range $key := regexSplit "[.]" $persistenceInfosLabel -1 -}}
{{- $persistenceInfos = index $persistenceInfos $key -}}
{{- end -}}
{{- if and (index $persistenceInfos "enabled") (not (index $persistenceInfos  "existingClaim")) -}}
{{- if (include "common.needPV" $dot) -}}
{{- $labels := default (dict) (index $persistenceInfos "labels") }}
{{/* TODO: see if we can use "common.PV" after branching F release */}}
{{- range $i := until (int $dot.Values.replicaCount)}}
{{- $range_suffix := printf "%s-%s" $suffix $i}}
---
kind: PersistentVolume
apiVersion: v1
metadata: {{- include "common.resourceMetadata" (dict "dot" $dot "suffix" $range_suffix "labels" $labels) | nindent 2 }}
spec:
  capacity:
    storage: {{ index $persistenceInfos "size" }}
  accessModes:
    - {{ index $persistenceInfos "accessMode" }}
  persistentVolumeReclaimPolicy: {{ index $persistenceInfos "volumeReclaimPolicy" }}
  storageClassName: "{{ include "common.fullname" $dot }}-{{ $suffix }}"
  hostPath:
    path: {{ include "common.persistencePath"  (dict "dot" $dot "subPath" (index $persistenceInfos "mountSubPath")) }}-{{$i}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
  Generate a PVC

  The function takes up to two arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix: suffix to name. if not set, default to "data".
     - .persistenceInfos: the persitence values to use, default to
                          "persistence".
                          Need to be the path from `.Values` in string format.
                          let's say you have:

                              persistence:
                                logs:
                                  enabled: true
                                  size: 100Mi
                                  accessMode: ReadWriteOnce
                                  ...

                          then you have to put "persitence.logs" in order to use
                          it.

  Example calls:
    {{ include "common.PVC" . }}
    {{ include "common.PVC" (dict "dot" . "suffix" "my-awesome-suffix" "persistenceInfos" .Values.persistenceLog) }}
    {{ include "common.PVC" (dict dot" . "subPath" "persistenceInfos" .Values.persistence.log) }}
*/}}
{{- define "common.PVC" -}}
{{- $dot := default . .dot -}}
{{- $persistenceInfosLabel := default "persistence" .persistenceInfos -}}
{{- $persistenceInfos := index $dot "Values" }}
{{- range $key := regexSplit "[.]" $persistenceInfosLabel -1 -}}
{{- $persistenceInfos = index $persistenceInfos $key -}}
{{- end -}}
{{- $suffix := default "data" .suffix -}}
{{- $metadata_suffix := "" -}}
{{- if ne $suffix "data" -}}
{{- $metadata_suffix = $suffix -}}
{{- end -}}
{{- if and (index $persistenceInfos "enabled") (not (index $persistenceInfos "existingClaim")) -}}
kind: PersistentVolumeClaim
apiVersion: v1
metadata: {{- include "common.resourceMetadata" (dict "dot" $dot "suffix" $metadata_suffix) | nindent 2 }}
{{- if (index $persistenceInfos "annotations") }}
  annotations: {{ toYaml (index $persistenceInfos "annotations") | nindent 4 }}
{{- end }}
spec:
  accessModes:
    - {{ index $persistenceInfos "accessMode" }}
  storageClassName: {{ include "common.storageClass" (dict "dot" $dot "suffix" $suffix) }}
  resources:
    requests:
      storage: {{ index $persistenceInfos "size" }}
{{- end -}}
{{- end -}}

{{/*
  Generate a PVC template for a statefulset

  The function takes up to two arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix: suffix to name. if not set, default to "data".
     - .persistenceInfos: the persitence values to use, default to
                          "persistence".
                          Need to be the path from `.Values` in string format.
                          let's say you have:

                              persistence:
                                logs:
                                  enabled: true
                                  size: 100Mi
                                  accessMode: ReadWriteOnce
                                  ...

                          then you have to put "persitence.logs" in order to use
                          it.

  Example calls:
    {{ include "common.PVCTemplate" . }}
    {{ include "common.PVCTemplate" (dict "dot" . "suffix" "my-awesome-suffix" "persistenceInfos" .Values.persistenceLog) }}
    {{ include "common.PVCTemplate" (dict dot" . "subPath" "persistenceInfos" .Values.persistence.log) }}
*/}}
{{- define "common.PVCTemplate" -}}
{{- $dot := default . .dot -}}
{{- $persistenceInfosLabel := default "persistence" .persistenceInfos -}}
{{- $persistenceInfos := index $dot "Values" }}
{{- range $key := regexSplit "[.]" $persistenceInfosLabel -1 -}}
{{- $persistenceInfos = index $persistenceInfos $key -}}
{{- end -}}
{{- $suffix := default "data" .suffix -}}
{{- $metadata_suffix := "" -}}
{{- if ne $suffix "data" -}}
{{- $metadata_suffix = $suffix -}}
{{- end -}}
metadata: {{- include "common.resourceMetadata" (dict "dot" $dot "suffix" $metadata_suffix) | nindent 2 }}
spec:
  accessModes:
  - {{ index $persistenceInfos "accessMode" }}
  storageClassName: {{ include "common.storageClass" (dict "dot" $dot "suffix" $suffix "persistenceInfos" $persistenceInfosLabel ) }}
  resources:
    requests:
      storage: {{ index $persistenceInfos "size" }}
{{- end -}}
