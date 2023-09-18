{*/
# Copyright © 2020 AT&T, Orange
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
*/}

{{- define "aaf.deployment" -}}
apiVersion: apps/v1
kind: Deployment
metadata: {{- include "common.resourceMetadata" . | nindent 2 }}
spec:
  selector: {{- include "common.selectors" . | nindent 4 }}
  replicas: {{ .Values.replicaCount }}
  template:
    metadata: {{- include "common.templateMetadata" . | nindent 6 }}
      {{- if (include "common.onServiceMesh" .) }}
      annotations:
        sidecar.istio.io/inject: "false"
      {{- end }}
    spec: {{ include "aaf.initContainers" . | nindent 6 }}
      containers:
      - name: {{ include "common.name" . }}
        workingDir: /opt/app/aaf
        command: ["bin/{{ .Values.binary }}"]
        image: {{ include "repositoryGenerator.repository" . }}/{{.Values.global.aaf.image}}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        ports: {{ include "common.containerPorts" . | nindent 10  }}
        volumeMounts:
        - mountPath: "/opt/app/osaaf"
          name: aaf-config-vol
        - mountPath: /etc/localtime
          name: localtime
          readOnly: true
        - mountPath: /opt/app/osaaf/etc/org.osaaf.aaf.log4j.props
          name: aaf-log
          subPath: org.osaaf.aaf.log4j.props
        - mountPath: /opt/app/osaaf/data/
          name: config-identity
        {{- if eq .Values.liveness.enabled true }}
        livenessProbe:
          tcpSocket:
            port: {{.Values.liveness.port }}
          initialDelaySeconds: {{ .Values.liveness.initialDelaySeconds }}
          periodSeconds: {{ .Values.liveness.periodSeconds }}
        {{ end -}}
        readinessProbe:
          tcpSocket:
            port: {{ .Values.readiness.port }}
          initialDelaySeconds: {{ .Values.readiness.initialDelaySeconds }}
          periodSeconds: {{ .Values.readiness.periodSeconds }}
        resources: {{ include "common.resources" . | nindent 12 }}
      {{- if .Values.nodeSelector }}
      nodeSelector: {{ toYaml .Values.nodeSelector | nindent 10 }}
      {{- end -}}
      {{- if .Values.affinity }}
      affinity: {{ toYaml .Values.affinity | nindent 10 }}
      {{- end }}
      volumes:
      - name: aaf-agent-certs
        configMap:
          name: {{ include "common.release" . }}-cert-wrapper-certs
          defaultMode: 448
      - name: ca-certs
        secret:
          secretName: {{ include "common.release" . }}-aaf-sms-int-certs
      - name: localtime
        hostPath:
          path: /etc/localtime
      - name: aaf-config-vol
        emptyDir: {}
      - name: aaf-log
        configMap:
          name: {{ include "common.release" . }}-aaf-log
      - name: config-init-identity
        configMap:
          name: {{ include "common.release" . }}-aaf-identity
      - name: config-identity
        emptyDir: {}
      imagePullSecrets:
      - name: "{{ include "common.namespace" . }}-docker-registry-key"
{{- end -}}
