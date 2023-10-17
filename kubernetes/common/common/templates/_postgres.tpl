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
{{- $dbname := (required "'dbame' param, is required." .dbname) -}}
{{- $dbinst := (required "'dbinst' param, is required." .dbinst) -}}
---
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: {{ $dbname }}
spec:
  {{- if .Values.imagePostgres }}
  image: {{ .Values.imagePostgres | quote }}
  {{- end }}
  {{- if .Values.port }}
  port: {{ .Values.port }}
  {{- end }}
  postgresVersion: {{ required "You must set the version of Postgres to deploy." .Values.postgresVersion }}
  {{- if .Values.instances }}
  instances:
  {{ toYaml .Values.instances | indent 4 }}
  {{- else }}
  instances:
    - name: {{ default "instance1" .Values.instanceName | quote }}
      replicas: {{ default 1 .Values.instanceReplicas }}
      dataVolumeClaimSpec:
        {{- if .Values.instanceStorageClassName }}
        storageClassName: {{ .Values.instanceStorageClassName | quote }}
        {{- end }}
        accessModes:
        - "ReadWriteOnce"
        resources:
          requests:
            storage: {{ default "1Gi" .Values.instanceSize | quote }}
      {{- if or .Values.instanceMemory .Values.instanceCPU }}
      resources:
        limits:
          cpu: {{ default "" .Values.instanceCPU | quote }}
          memory: {{ default "" .Values.instanceMemory | quote }}
      {{- end }}
  {{- end }}
  backups:
    pgbackrest:
      {{- if .Values.imagePgBackRest }}
      image: {{ .Values.imagePgBackRest | quote }}
      {{- end }}
	  {{- if .Values.pgBackRestConfig }}
      {{ toYaml .Values.pgBackRestConfig | indent 6 }}
      {{- else if .Values.multiBackupRepos }}
	  configuration:
      - secret:
          name: {{ default .Release.Name .Values.name }}-pgbackrest-secret
      global:
        {{- range $index, $repo := .Values.multiBackupRepos }}
        {{- if or $repo.s3 $repo.gcs $repo.azure }}
        repo{{ add $index 1 }}-path: /pgbackrest/{{ $.Release.Namespace }}/{{ default $.Release.Name $.Values.name }}/repo{{ add $index 1 }}
        {{- end }}
        {{- end }}
      repos:
      {{- range $index, $repo := .Values.multiBackupRepos }}
      - name: repo{{ add $index 1 }}
        {{- if $repo.volume }}
		volume:
          volumeClaimSpec:
            {{- if $repo.volume.backupsStorageClassName }}
            storageClassName: {{ .Values.backupsStorageClassName | quote }}
            {{- end }}
            accessModes:
            - "ReadWriteOnce"
            resources:
              requests:
                storage: {{ default "1Gi" $repo.volume.backupsSize | quote }}
        {{- else if $repo.s3 }}
		s3:
          bucket: {{ $repo.s3.bucket | quote }}
          endpoint: {{ $repo.s3.endpoint | quote }}
          region: {{ $repo.s3.region | quote }}
        {{- else if $repo.gcs }}
		gcs:
          bucket: {{ $repo.gcs.bucket | quote }}
        {{- else if $repo.azure }}
        azure:
          container: {{ $repo.azure.container | quote }}
        {{- end }}
      {{- end }}
	  {{- else if .Values.s3 }}
      configuration:
      - secret:
          name: {{ default .Release.Name .Values.name }}-pgbackrest-secret
	  global:
        repo1-path: /pgbackrest/{{ .Release.Namespace }}/{{ default .Release.Name .Values.name }}/repo1
        {{- if .Values.s3.encryptionPassphrase }}
        repo1-cipher-type: aes-256-cbc
        {{- end }}
      repos:
      - name: repo1
        s3:
          bucket: {{ .Values.s3.bucket | quote }}
          endpoint: {{ .Values.s3.endpoint | quote }}
          region: {{ .Values.s3.region | quote }}
      {{- else if .Values.gcs }}
      configuration:
      - secret:
          name: {{ default .Release.Name .Values.name }}-pgbackrest-secret
      global:
        repo1-path: /pgbackrest/{{ .Release.Namespace }}/{{ default .Release.Name .Values.name }}/repo1
      repos:
      - name: repo1
        gcs:
          bucket: {{ .Values.gcs.bucket | quote }}
      {{- else if .Values.azure }}
      configuration:
      - secret:
          name: {{ default .Release.Name .Values.name }}-pgbackrest-secret
      global:
        repo1-path: /pgbackrest/{{ .Release.Namespace }}/{{ default .Release.Name .Values.name }}/repo1
      repos:
      - name: repo1
        azure:
          container: {{ .Values.azure.container | quote }}
      {{- else }}
      repos:
      - name: repo1
        volume:
          volumeClaimSpec:
            {{- if .Values.backupsStorageClassName }}
            storageClassName: {{ .Values.backupsStorageClassName | quote }}
            {{- end }}
            accessModes:
            - "ReadWriteOnce"
            resources:
              requests:
                storage: {{ default "1Gi" .Values.backupsSize | quote }}
      {{- end }}
  {{- if or .Values.pgBouncerReplicas .Values.pgBouncerConfig }}
  proxy:
    pgBouncer:
      {{- if .Values.imagePgBouncer }}
      image: {{ .Values.imagePgBouncer | quote }}
      {{- end }}
	  {{- if .Values.pgBouncerConfig }}
      {{ toYaml .Values.pgBouncerConfig | indent 6 }}
      {{- else }}
      replicas: {{ .Values.pgBouncerReplicas }}
      {{- end }}
	  {{- if .Values.patroni }}
      patroni:
      {{ toYaml .Values.patroni | indent 4 }}
      {{- end }}
      {{- if .Values.users }}
      users:
      {{ toYaml .Values.users | indent 4 }}
      {{- end }}
	  {{- if .Values.service }}
      service:
      {{ toYaml .Values.service | indent 4 }}
      {{- end }}
	  {{- if .Values.dataSource }}
      dataSource:
      {{ toYaml .Values.dataSource | indent 4 }}
      {{- end }}
	  {{- if .Values.databaseInitSQL }}
      databaseInitSQL:
        name: {{ required "A ConfigMap name is required for running bootstrap SQL." .Values.databaseInitSQL.name | quote }}
        key: {{ required "A key in a ConfigMap containing any bootstrap SQL is required." .Values.databaseInitSQL.key | quote }}
      {{- end }}
      {{- if .Values.imagePullPolicy }}
      imagePullPolicy: {{ .Values.imagePullPolicy | quote }}
      {{- end }}
	  {{- if .Values.imagePullSecrets }}
      imagePullSecrets:
      {{ toYaml .Values.imagePullSecrets | indent 4 }}
      {{- end }}
	  {{- if .Values.disableDefaultPodScheduling }}
      disableDefaultPodScheduling: true
      {{- end }}
	  {{- if .Values.metadata }}
      metadata:
      {{ toYaml .Values.metadata | indent 4 }}
      {{- end }}
	  {{- if .Values.shutdown }}
      shutdown: true
      {{- end }}
      {{- if .Values.standby }}
      standby:
        enabled: {{ .Values.standby.enabled }}
        repoName: {{ .Values.standby.repoName }}
        host: {{ .Values.standby.host }}
        port: {{ .Values.standby.port }}
      {{- end }}
	  {{- if .Values.customTLSSecret }}
      customTLSSecret:
      {{ toYaml .Values.customTLSSecret | indent 4 }}
      {{- end }}
	  {{- if .Values.customReplicationTLSSecret }}
      customReplicationTLSSecret:
      {{ toYaml .Values.customReplicationTLSSecret | indent 4 }}
      {{- end }}
{{- end -}}
