{{/*
# Copyright © 2019 Samsung Electronics
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
  UID of mongodb root password
*/}}
{{- define "common.mongodb.secret.rootPassUID" -}}
  {{- printf "db-root-password" }}
{{- end -}}

{{/*
  Name of mongodb secret
*/}}
{{- define "common.mongodb.secret._secretName" -}}
  {{- $global := .dot }}
  {{- $chartName := tpl .chartName $global -}}
  {{- include "common.secret.genName" (dict "global" $global "uid" (include .uidTemplate $global) "chartName" $chartName) }}
{{- end -}}

{{/*
  Name of mongodb root password secret
*/}}
{{- define "common.mongodb.secret.rootPassSecretName" -}}
  {{- include "common.mongodb.secret._secretName" (set . "uidTemplate" "common.mongodb.secret.rootPassUID") }}
{{- end -}}

{{/*
  UID of mongodb user credentials
*/}}
{{- define "common.mongodb.secret.userCredentialsUID" -}}
  {{- printf "db-user-credentials" }}
{{- end -}}

{{/*
  Name of mongodb user credentials secret
*/}}
{{- define "common.mongodb.secret.userCredentialsSecretName" -}}
  {{- include "common.mongodb.secret._secretName" (set . "uidTemplate" "common.mongodb.secret.userCredentialsUID") }}
{{- end -}}

{{/*
  UID of mongodb primary password
*/}}
{{- define "common.mongodb.secret.primaryPasswordUID" -}}
  {{- printf "primary-password" }}
{{- end -}}

{{/*
  Name of mongodb user credentials secret
*/}}
{{- define "common.mongodb.secret.primaryPasswordSecretName" -}}
  {{- include "common.mongodb.secret._secretName" (set . "uidTemplate" "common.mongodb.secret.primaryPasswordUID") }}
{{- end -}}

{{/*
  Choose the name of the mongodb app label to use.
*/}}
{{- define "common.mongodbAppName" -}}
  {{- if .Values.global.mongodb.localCluster -}}
    {{- index .Values "mongodb" "nameOverride" -}}
  {{- else -}}
    {{- .Values.global.mongodb.nameOverride -}}
  {{- end -}}
{{- end -}}

#Not edited yet
{{/*
  Create mongodb cluster via mongodb percona-operator
*/}}
{{- define "common.mongodbOpInstance" -}}
{{- $dot := default . .dot -}}
{{- $global := $dot.Values.global -}}
{{- $dbinst := include "common.name" $dot -}}
---

apiVersion: psmdb.percona.com/v1
kind: PerconaServerMongoDB
metadata:
  name: {{ $dbinst }}
  labels:
    app: {{ $dbinst }}
    version: "5.5"
spec:
  metadata:
    labels:
      app: {{ $dbinst }}
      version: "5.5"
  {{- if .Values.mongodbOperator.imageMongo }}
  image: {{ .Values.mongodbOperator.imageMongo | quote }}
  {{- end }}
  imagePullSecrets:
    - name: {{ include "common.namespace" . }}-docker-registry-key
  mongodbVersion: {{ $dot.Values.mongodbOperator.mongodbVersion }}
  instances:
    - name: {{ default "instance1" .Values.mongodbOperator.instanceName | quote }}
      replicas: {{ default 2 .Values.mongodbOperator.instanceReplicas }}
      dataVolumeClaimSpec:
        {{- if .Values.instanceStorageClassName }}
        storageClassName: {{ .Values.mongodbOperator.instanceStorageClassName | quote }}
        {{- end }}
        accessModes:
        - "ReadWriteOnce"
        resources:
          requests:
            storage: {{ default "1Gi" .Values.mongodbOperator.instanceSize | quote }}
      {{- if or .Values.instanceMemory .Values.mongodbOperator.instanceCPU }}
      resources:
        limits:
          cpu: {{ default "" .Values.mongodbOperator.instanceCPU | quote }}
          memory: {{ default "" .Values.mongodbOperator.instanceMemory | quote }}
      {{- end }}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  mongodb-operator.crunchydata.com/cluster: {{ $dbinst }}
                  mongodb-operator.crunchydata.com/instance-set: {{ default "instance1" .Values.mongodbOperator.instanceName | quote }}
  proxy:
    pgBouncer:
      metadata:
        labels:
          app: {{ $dbinst }}
          version: "5.5"
      {{- if .Values.mongodbOperator.imagePgBouncer }}
      image: {{ .Values.mongodbOperator.imagePgBouncer | quote }}
      {{- end }}
      replicas: {{ default 2 .Values.mongodbOperator.bouncerReplicas }}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  mongodb-operator.crunchydata.com/cluster: {{ $dbinst }}
                  mongodb-operator.crunchydata.com/role: pgbouncer
  {{- if .Values.mongodbOperator.monitoring }}
  monitoring:
    pgmonitor:
      exporter:
        image: {{ default "" .Values.mongodbOperator.imageExporter | quote }}
        {{- if .Values.mongodbOperator.monitoringConfig }}
{{ toYaml .Values.monitoringConfig | indent 8 }}
        {{- end }}
  {{- end }}
  users:
    - name: mongodb
{{- end -}}
