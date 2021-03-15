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

{{- define "common.log.sidecar" -}}
{{- if .Values.global.centralizedLoggingEnabled }}
- name: {{ include "common.name" . }}-filebeat
  image: "{{ .Values.global.loggingRepository }}/{{ .Values.global.loggingImage }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  volumeMounts:
  - name: filebeat-conf
    mountPath: /usr/share/filebeat/filebeat.yml
    subPath: filebeat.yml
  - name: logs
    mountPath: {{ .Values.log.path }}
  - name: filebeat-data
    mountPath: /usr/share/filebeat/data
{{- end -}}
{{- end -}}

{{- define "common.log.volumes" -}}
{{- if .Values.global.centralizedLoggingEnabled }}
- name: filebeat-conf
  configMap:
    name: {{ include "common.fullname" . }}-filebeat
- name: filebeat-data
  emptyDir: {}
{{- end -}}
{{- end -}}

{{- define "common.log.configMap" -}}
{{- if .Values.global.centralizedLoggingEnabled }}
---
apiVersion: v1
kind: ConfigMap
metadata: {{- include "common.resourceMetadata" (dict "dot" . "suffix" "filebeat") | nindent 2 }}
data:
{{ tpl (.Files.Glob "resources/config/log/filebeat/*").AsConfig . | indent 2 }}
{{- end }}
{{- end -}}

