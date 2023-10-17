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
  UID of postgres root password
*/}}
{{- define "common.postgres.secret.rootPassUID" -}}
  {{- printf "db-root-password" }}
{{- end -}}

{{/*
  Name of postgres secret
*/}}
{{- define "common.postgres.secret._secretName" -}}
  {{- $global := .dot }}
  {{- $chartName := tpl .chartName $global -}}
  {{- include "common.secret.genName" (dict "global" $global "uid" (include .uidTemplate $global) "chartName" $chartName) }}
{{- end -}}

{{/*
  Name of postgres root password secret
*/}}
{{- define "common.postgres.secret.rootPassSecretName" -}}
  {{- include "common.postgres.secret._secretName" (set . "uidTemplate" "common.postgres.secret.rootPassUID") }}
{{- end -}}

{{/*
  UID of postgres user credentials
*/}}
{{- define "common.postgres.secret.userCredentialsUID" -}}
  {{- printf "db-user-credentials" }}
{{- end -}}

{{/*
  Name of postgres user credentials secret
*/}}
{{- define "common.postgres.secret.userCredentialsSecretName" -}}
  {{- include "common.postgres.secret._secretName" (set . "uidTemplate" "common.postgres.secret.userCredentialsUID") }}
{{- end -}}

{{/*
  UID of postgres primary password
*/}}
{{- define "common.postgres.secret.primaryPasswordUID" -}}
  {{- printf "primary-password" }}
{{- end -}}

{{/*
  Name of postgres user credentials secret
*/}}
{{- define "common.postgres.secret.primaryPasswordSecretName" -}}
  {{- include "common.postgres.secret._secretName" (set . "uidTemplate" "common.postgres.secret.primaryPasswordUID") }}
{{- end -}}

{{/*
  Create postgres cluster via postgres crunchydata-operator
*/}}
{{- define "common.postgresOpInstance" -}}
{{- $dot := default . .dot -}}
{{- $global := $dot.Values.global -}}
{{- $dbname := (required "'dbame' param, is required." .dbname) -}}
---
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
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
  {{- if .Values.postgresOperator.imagePostgres }}
  image: {{ .Values.postgresOperator.imagePostgres | quote }}
  {{- end }}
  imagePullSecrets:
    - name: {{ include "common.namespace" . }}-docker-registry-key
  postgresVersion: {{ $dot.Values.postgresOperator.postgresVersion }}
  instances:
    - name: {{ default "instance1" .Values.postgresOperator.instanceName | quote }}
      replicas: {{ default 2 .Values.postgresOperator.instanceReplicas }}
      dataVolumeClaimSpec:
        {{- if .Values.instanceStorageClassName }}
        storageClassName: {{ .Values.postgresOperator.instanceStorageClassName | quote }}
        {{- end }}
        accessModes:
        - "ReadWriteOnce"
        resources:
          requests:
            storage: {{ default "1Gi" .Values.postgresOperator.instanceSize | quote }}
      {{- if or .Values.instanceMemory .Values.postgresOperator.instanceCPU }}
      resources:
        limits:
          cpu: {{ default "" .Values.postgresOperator.instanceCPU | quote }}
          memory: {{ default "" .Values.postgresOperator.instanceMemory | quote }}
      {{- end }}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  postgres-operator.crunchydata.com/cluster: {{ $dbinst }}
                  postgres-operator.crunchydata.com/instance-set: {{ default "instance1" .Values.postgresOperator.instanceName | quote }}
  proxy:
    pgBouncer:
      metadata:
        labels:
          app: {{ $dbinst }}
          version: "5.5"
      {{- if .Values.postgresOperator.imagePgBouncer }}
      image: {{ .Values.postgresOperator.imagePgBouncer | quote }}
      {{- end }}
      replicas: {{ default 2 .Values.postgresOperator.bouncerReplicas }}
      affinity:
        podAntiAffinity:
          preferredDuringSchedulingIgnoredDuringExecution:
          - weight: 1
            podAffinityTerm:
              topologyKey: kubernetes.io/hostname
              labelSelector:
                matchLabels:
                  postgres-operator.crunchydata.com/cluster: {{ $dbinst }}
                  postgres-operator.crunchydata.com/role: pgbouncer
  {{- if .Values.postgresOperator.monitoring }}
  monitoring:
    pgmonitor:
      exporter:
        image: {{ default "" .Values.postgresOperator.imageExporter | quote }}
        {{- if .Values.postgresOperator.monitoringConfig }}
{{ toYaml .Values.monitoringConfig | indent 8 }}
        {{- end }}
  {{- end }}
  {{- end }}
  #{{- if .Values.postgresOperator.backupEnabled }}
  #backups:
  #  pgbackrest:
  #    metadata:
  #      labels:
  #        app: {{ $dbinst }}
  #        version: "5.5"
  #        sidecar.istio.io/inject: 'false'
  #    {{- if .Values.postgresOperator.imagePgBackRest }}
  #    image: {{ .Values.postgresOperator.imagePgBackRest | quote }}
  #    {{- end }}
  #  configuration:
  #    - secret:
  #        name: pgo-s3-creds
  #    global:
  #      repo1-retention-full: "3"
  #      repo1-retention-full-type: count
  #      repo1-s3-uri-style: path
  #      repo1-path: /pgbackrest/postgres-operator/postgres-$PARAM_UC/repo1
  #    repos:
  #    - name: repo1
  #      schedules:
  #        full: "0 1 * * 0"
  #      s3:
  #        bucket: "dev-monitoring-bucket"
  #        endpoint: "storage09-api.tnaplab.telekom.de"
  #        region: "ta5"
  #{{- end }}
  #userInterface:
  #  pgAdmin:
  #    #image: artifactory.devops.telekom.de/registry.developers.crunchydata.com/crunchydata/crunchy-pgadmin4:ubi8-4.30-19
  #    dataVolumeClaimSpec:
  #      accessModes:
  #      - "ReadWriteOnce"
  #      resources:
  #        requests:
  #          storage: 1Gi
  users:
    - name: postgres
{{- end -}}
