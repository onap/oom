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
  Create Postgres cluster deployment
*/}}

apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ .Chart.Name }}
  labels:
    {{- include "install.labels" . | nindent 4 }}
    {{- include "install.clusterLabels" . | nindent 4 }}
spec:
  replicas: 1
  strategy: { type: Recreate }
  selector:
    matchLabels:
      {{- include "install.clusterLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "install.clusterLabels" . | nindent 8 }}
        {{- include "install.customPodLabels" . | nindent 8 }}
    spec:
      {{- include "install.imagePullSecrets" . | indent 6 }}
      serviceAccountName: {{ include "install.serviceAccountName" . }}
      containers:
      - name: operator
        image: {{ required ".Values.controllerImages.cluster is required" .Values.controllerImages.cluster | quote }}
        env:
        - name: CRUNCHY_DEBUG
          value: {{ .Values.debug | ne false | quote }}
        - name: PGO_NAMESPACE
          valueFrom: { fieldRef: { apiVersion: v1, fieldPath: metadata.namespace } }
        - name: PGO_TARGET_NAMESPACE
          valueFrom: { fieldRef: { apiVersion: v1, fieldPath: metadata.namespace } }
        {{- include "install.relatedImages" . | indent 8 }}
        {{- if .Values.disable_check_for_upgrades }}
        - name: CHECK_FOR_UPGRADES
          value: "false"
        {{- end }}
        {{- if .Values.resources.controller }}
        resources:
        {{- toYaml .Values.resources.controller | nindent 10 }}
        {{- end }}
        securityContext:
          allowPrivilegeEscalation: false
          capabilities: { drop: [ALL] }
          readOnlyRootFilesystem: true
          runAsNonRoot: true

{{/*
  Create postgres cluster via postgres crunchydata-operator
*/}}
{{- $dbname := (required "'dbame' param, is required." .dbname) -}}
---
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: {{ $dbname }}
spec:
  image: {{ .Values.postgresOperator.imagePostgres}}
  port: {{ .Values.postgresOperator.port }}
  postgresVersion: {{ required "You must set the version of Postgres to deploy." .Values.postgresOperator.postgresVersion }}
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
      image: {{ .Values.postgresOperator.imagePgBackRest | quote }}
	  {{- if .Values.postgresOperator.pgBackRestConfig }}
      {{ toYaml .Values.postgresOperator.pgBackRestConfig | indent 6 }}
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
	    schedules:
		  full: "0 1 * * *"
		  incremental: "0 */2 * * *"
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
                storage: {{ default "1Gi" .Values.postgresOperator.backupsSize | quote }}
      {{- end }}
  {{- if or .Values.postgresOperator.pgBouncerReplicas .Values.postgresOperator.pgBouncerConfig }}
  proxy:
    pgBouncer:
      {{- if .Values.postgresOperator.imagePgBouncer }}
      image: {{ .Values.postgresOperator.imagePgBouncer | quote }}
      {{- end }}
	  {{- if .Values.postgresOperator.pgBouncerConfig }}
      {{ toYaml .Values.postgresOperator.pgBouncerConfig | indent 6 }}
      {{- else }}
      replicas: {{ .Values.postgresOperator.pgBouncerReplicas }}
      {{- end }}
	  {{- if .Values.postgresOperator.patroni }}
      patroni:
      {{ toYaml .Values.postgresOperator.patroni | indent 4 }}
      {{- end }}
      {{- if .Values.postgresOperator.users }}
      users:
      {{ toYaml .Values.postgresOperator.users | indent 4 }}
      {{- end }}
	  {{- if .Values.postgresOperator.service }}
      service:
      {{ toYaml .Values.postgresOperator.service | indent 4 }}
      {{- end }}
	  {{- if .Values.postgresOperator.dataSource }}
      dataSource:
      {{ toYaml .Values.postgresOperator.dataSource | indent 4 }}
      {{- end }}
	  {{- if .Values.postgresOperator.databaseInitSQL }}
      databaseInitSQL:
        name: {{ required "A ConfigMap name is required for running bootstrap SQL." .Values.postgresOperator.databaseInitSQL.name | quote }}
        key: {{ required "A key in a ConfigMap containing any bootstrap SQL is required." .Values.postgresOperator.databaseInitSQL.key | quote }}
      {{- end }}
      {{- if .Values.postgresOperator.imagePullPolicy }}
      imagePullPolicy: {{ .Values.postgresOperator.imagePullPolicy | quote }}
      {{- end }}
	  {{- if .Values.postgresOperator.imagePullSecrets }}
      imagePullSecrets:
      {{ toYaml .Values.postgresOperator.imagePullSecrets | indent 4 }}
      {{- end }}
	  {{- if .Values.postgresOperator.disableDefaultPodScheduling }}
      disableDefaultPodScheduling: true
      {{- end }}
	  {{- if .Values.postgresOperator.metadata }}
      metadata:
      {{ toYaml .Values.postgresOperator.metadata | indent 4 }}
      {{- end }}
	  {{- if .Values.postgresOperator.shutdown }}
      shutdown: true
      {{- end }}
      {{- if .Values.postgresOperator.standby }}
      standby:
        enabled: {{ .Values.postgresOperator.standby.enabled }}
        repoName: {{ .Values.postgresOperator.standby.repoName }}
        host: {{ .Values.postgresOperator.standby.host }}
        port: {{ .Values.postgresOperator.standby.port }}
      {{- end }}
	  {{- if .Values.postgresOperator.customTLSSecret }}
      customTLSSecret:
      {{ toYaml .Values.postgresOperator.customTLSSecret | indent 4 }}
      {{- end }}
	  {{- if .Values.postgresOperator.customReplicationTLSSecret }}
      customReplicationTLSSecret:
      {{ toYaml .Values.postgresOperator.customReplicationTLSSecret | indent 4 }}
      {{- end }}
{{- end -}}
