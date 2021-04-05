{{/*
################################################################################
#   Copyright (c) 2021 Nordix Foundation.                                      #
#                                                                              #
#   Licensed under the Apache License, Version 2.0 (the "License");            #
#   you may not use this file except in compliance with the License.           #
#   You may obtain a copy of the License at                                    #
#                                                                              #
#       http://www.apache.org/licenses/LICENSE-2.0                             #
#                                                                              #
#   Unless required by applicable law or agreed to in writing, software        #
#   distributed under the License is distributed on an "AS IS" BASIS,          #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#   See the License for the specific language governing permissions and        #
#   limitations under the License.                                             #
################################################################################
*/}}

{{/*
This template generates a Kubernetes Job to provision DMaaP topics
(on Message Router) and feeds (on Data Router), with associated authorization (on AAF).

DMaap Bus Controller endpoints are used to provision:
- Authorized topic on MR, and to create and grant permission for publishers and subscribers.
- Feed on DR, with associated user authentication.

The template expects the full chart context as input.
A chart references this template using: {{ include "common.dmaap-provisioning" . }}

The template directly references data in .Values, and indirectly (through its
use of templates from the ONAP "common" collection) references data in .Release.
*/}}

{{- define "common.dmaap-provisioning" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "common.fullname" . }}-dmaap-provisioning
  namespace: {{ include "common.namespace" . }}
  labels: {{- include "common.labels" . | nindent 4 }}
spec:
  backoffLimit: 20
  template:
    metadata: {{- include "common.templateMetadata" . | nindent 6 }}
    spec:
      restartPolicy: Never
      initContainers:
      - name: {{ include "common.name" . }}-init-readiness
        image: {{ include "repositoryGenerator.image.readiness" . }}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        command:
        - /app/ready.py
        args:
        - --container-name
        - dmaap-bc
        env:
        - name: NAMESPACE
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: metadata.namespace
      containers:
      - name: dmaap-provisioning-job
        image: {{ include "repositoryGenerator.repository" . }}/{{ .Values.global.clientImage }}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        env:
        - name: DELAY
          value: "0"
    {{- if .Values.global.allow_http }}
        - name: PROTO
          value: "http"
        - name: PORT
          value: "8080"
    {{ end }}
        - name: REQUESTID
          value: "{{.Chart.Name}}-dmaap-provisioning"
        volumeMounts:
        - mountPath: /etc/localtime
          name: localtime
          readOnly: true
# NOTE: on the following several configMaps, careful to include / at end
#       since there may be more than one file in each mountPath
# NOTE: the basename of the subdirectory of mountPath is important - it matches the DBCL API URI
        - name:  {{ include "common.fullname" . }}-dbc-dmaap
          mountPath: /opt/app/config/dmaap/
        - name:  {{ include "common.fullname" . }}-dbc-dcaelocations
          mountPath: /opt/app/config/dcaeLocations/
        - name:  {{ include "common.fullname" . }}-dr-nodes
          mountPath: /opt/app/config/dr_nodes/
        - name:  {{ include "common.fullname" . }}-feeds
          mountPath: /opt/app/config/feeds/
        - name:  {{ include "common.fullname" . }}-mr-clusters
          mountPath: /opt/app/config/mr_clusters/
        - name:  {{ include "common.fullname" . }}-topics
          mountPath: /opt/app/config/topics/
        resources: {{ include "common.resources" . | nindent 10 }}
        {{- if .Values.nodeSelector }}
      nodeSelector: {{ toYaml .Values.nodeSelector | nindent 8 }}
        {{- end -}}
        {{- if .Values.affinity }}
      affinity: {{ toYaml .Values.affinity | nindent 8 }}
        {{- end }}
      volumes:
        - name: localtime
          hostPath:
            path: /etc/localtime
        - name: {{ include "common.fullname" . }}-dbc-dmaap
          configMap:
            name: {{ include "common.fullname" . }}-dbc-dmaap
        - name: {{ include "common.fullname" . }}-dbc-dcaelocations
          configMap:
            name: {{ include "common.fullname" . }}-dbc-dcaelocations
        - name: {{ include "common.fullname" . }}-dr-nodes
          configMap:
            name: {{ include "common.fullname" . }}-dr-nodes
        - name: {{ include "common.fullname" . }}-feeds
          configMap:
            name: {{ include "common.fullname" . }}-feeds
        - name: {{ include "common.fullname" . }}-mr-clusters
          configMap:
            name: {{ include "common.fullname" . }}-mr-clusters
        - name: {{ include "common.fullname" . }}-topics
          configMap:
            name: {{ include "common.fullname" . }}-topics
      imagePullSecrets:
      - name: "{{ include "common.namespace" . }}-docker-registry-key"
{{- end -}}