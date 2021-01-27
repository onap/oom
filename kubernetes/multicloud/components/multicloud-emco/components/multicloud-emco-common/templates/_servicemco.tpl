{{/*
# Copyright 2021 Intel Corporation, Inc
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
{{- define "multicloud-emco.servicemco" -}}
{{- $common := dict "Values" .Values.common -}}
{{- $noCommon := omit .Values "common" -}}
{{- $overrides := dict "Values" $noCommon -}}
{{- $noValues := omit . "Values" -}}
{{- with merge $noValues $overrides $common -}}
apiVersion: v1
kind: Service
metadata:
  name: {{ include "common.servicename" . }}
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 4 }}
spec:
  type: {{ .Values.service.type }}
  ports:
  - name: {{ .Values.service.PortName }}
    {{if eq .Values.service.type "NodePort" -}}
    port: {{ .Values.service.internalPort }}
    nodePort: {{ .Values.global.nodePortPrefixExt | default "302" }}{{ .Values.service.nodePort }}
    {{- else -}}
    port: {{ .Values.service.externalPort }}
    targetPort: {{ .Values.service.internalPort }}
    {{- end}}
    protocol: TCP
  selector: {{ include "common.matchLabels" . | nindent 4 }}
{{- end -}}
{{- end -}}