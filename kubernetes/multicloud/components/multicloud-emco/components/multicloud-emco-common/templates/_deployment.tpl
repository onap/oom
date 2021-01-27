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
{{- define "multicloud-emco.deployment" -}}
{{- $common := dict "Values" .Values.common -}}
{{- $noCommon := omit .Values "common" -}}
{{- $overrides := dict "Values" $noCommon -}}
{{- $noValues := omit . "Values" -}}
{{- with merge $noValues $overrides $common -}}
apiVersion: apps/v1
kind: Deployment
metadata: {{- include "common.resourceMetadata" . | nindent 2 }}
spec:
  selector: {{- include "common.selectors" . | nindent 4 }}
  replicas: {{ .Values.replicaCount }}
  template:
    metadata: {{- include "common.templateMetadata" . | nindent 6 }}
    spec:
      containers:
      - image: {{ include "repositoryGenerator.repository" . }}/{{ .Values.image }}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        name: {{ include "common.name" . }}
        command: [{{ .Values.command }}]
        args: [{{ .Values.args }}]
        workingDir: {{ .Values.workingDir }}
        ports:
        {{- if .Values.serviceInternal -}}
        {{- if .Values.serviceInternal.internalPort }}
        - containerPort: {{ .Values.serviceInternal.internalPort }}
        {{- end -}}
        {{- end }}
        - containerPort: {{ .Values.service.internalPort }}
        {{- if eq .Values.liveness.enabled true }}
        livenessProbe:
          tcpSocket:
            port: {{ .Values.service.internalPort }}
          initialDelaySeconds: {{ .Values.liveness.initialDelaySeconds }}
          periodSeconds: {{ .Values.liveness.periodSeconds }}
        {{ end }}

        readinessProbe:
          tcpSocket:
            port: {{ .Values.service.internalPort }}
          initialDelaySeconds: {{ .Values.readiness.initialDelaySeconds }}
          periodSeconds: {{ .Values.readiness.periodSeconds }}
        volumeMounts:
          - mountPath: /etc/localtime
            name: localtime
            readOnly: true
          - mountPath: {{ .Values.workingDir }}/config.json 
            name: {{ include "common.name" .}}
            subPath: config.json
        resources:
{{ include "common.resources" .  }}
        {{- if .Values.nodeSelector }}
        nodeSelector:
{{ toYaml .Values.nodeSelector  }}
        {{- end -}}
        {{- if .Values.affinity }}
        affinity:
{{ toYaml .Values.affinity  }}
        {{- end }}
      volumes:
      - name: localtime
        hostPath:
          path: /etc/localtime
      - name : {{ include "common.name" . }}
        configMap:
          name: {{ include "common.fullname" . }}
      imagePullSecrets:
      - name: "{{ include "common.namespace" . }}-docker-registry-key"
{{- end -}}
{{- end -}}
