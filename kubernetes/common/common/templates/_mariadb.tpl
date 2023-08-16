{{/*
# Copyright © 2019 Orange
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
  UID of mariadb root password
*/}}
{{- define "common.mariadb.secret.rootPassUID" -}}
  {{- printf "db-root-password" }}
{{- end -}}

{{/*
  Name of mariadb secret
*/}}
{{- define "common.mariadb.secret._secretName" -}}
  {{- $global := .dot }}
  {{- $chartName := tpl .chartName $global -}}
  {{- include "common.secret.genName" (dict "global" $global "uid" (include .uidTemplate $global) "chartName" $chartName) }}
{{- end -}}

{{/*
  Name of mariadb root password secret
*/}}
{{- define "common.mariadb.secret.rootPassSecretName" -}}
  {{- include "common.mariadb.secret._secretName" (set . "uidTemplate" "common.mariadb.secret.rootPassUID") }}
{{- end -}}

{{/*
  UID of mariadb user credentials
*/}}
{{- define "common.mariadb.secret.userCredentialsUID" -}}
  {{- printf "db-user-credentials" }}
{{- end -}}

{{/*
  UID of mariadb backup credentials
*/}}
{{- define "common.mariadb.secret.backupCredentialsUID" -}}
  {{- printf "db-backup-credentials" }}
{{- end -}}

{{/*
  Name of mariadb user credentials secret
*/}}
{{- define "common.mariadb.secret.userCredentialsSecretName" -}}
  {{- include "common.mariadb.secret._secretName" (set . "uidTemplate" "common.mariadb.secret.userCredentialsUID") }}
{{- end -}}

{{/*
  Choose the name of the mariadb service to use.
*/}}
{{- define "common.mariadbService" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
    {{- index .Values "mariadb-galera" "nameOverride" -}}
  {{- else -}}
    {{- .Values.global.mariadbGalera.service -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of mariadb port to use.
*/}}
{{- define "common.mariadbPort" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
    {{- index .Values "mariadb-galera" "service" "internalPort" -}}
  {{- else -}}
    {{- .Values.global.mariadbGalera.internalPort -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of secret to retrieve user value.
*/}}
{{- define "common.mariadbSecret" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
    {{ printf "%s-%s-db-user-credentials" (include "common.fullname" .) (index .Values "mariadb-galera" "nameOverride") -}}
  {{- else -}}
    {{ printf "%s-%s-%s" ( include "common.release" .) (index .Values "mariadb-init" "nameOverride") (index .Values "mariadb-init" "config" "mysqlDatabase" ) -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of secret param to retrieve user value.
*/}}
{{- define "common.mariadbSecretParam" -}}
  {{ printf "password" -}}
{{- end -}}

{{/*
  Create MariDB Database via mariadb-operator
*/}}
{{- define "common.mariadbOpDatabase" -}}
{{- $dot := default . .dot -}}
{{- $dbname := (required "'dbame' param, is required." .dbname) -}}
{{- $dbinst := (required "'dbinst' param, is required." .dbinst) -}}
---
apiVersion: mariadb.mmontes.io/v1alpha1
kind: Database
metadata:
  name: {{ $dbname }}
spec:
  mariaDbRef:
    name: {{ $dbinst }}
  characterSet: utf8
  collate: utf8_general_ci
{{- end -}}

{{/*
  Create MariDB User via mariadb-operator
*/}}
{{- define "common.mariadbOpUser" -}}
{{- $dot := default . .dot -}}
{{- $dbuser := (required "'dbuser' param, is required." .dbuser) -}}
{{- $dbinst := (required "'dbinst' param, is required." .dbinst) -}}
{{- $dbsecret := (required "'dbsecret' param, is required." .dbsecret) -}}
---
apiVersion: mariadb.mmontes.io/v1alpha1
kind: User
metadata:
  name: {{ $dbuser }}
spec:
  # If you want the user to be created with a different name than the resource name
  # name: user-custom
  mariaDbRef:
    name: {{ $dbinst }}
  passwordSecretKeyRef:
    name: {{ $dbsecret }}
    key: password
  # This field is immutable and defaults to 10
  maxUserConnections: 20
{{- end -}}

{{/*
S  Create a MariaDB instance via mariadb-operator
*/}}
{{- define "common.mariadbOpInstance" -}}
{{- $global := .Values.global }}
{{- $dbinst := include "common.mariadbService" . -}}
{{- $dbusersecret := include "common.mariadb.secret.userCredentialsSecretName" (dict "dot" . "chartName" .Values.global.mariadbGalera.nameOverride) -}}
---
apiVersion: mariadb.mmontes.io/v1alpha1
kind: MariaDB
metadata:
  name: {{ include "common.mariadbService" . }}
spec:
  podSecurityContext:
    runAsUser: 10001
    runAsGroup: 10001
    fsGroup: 10001
  inheritMetadata:
    {{ if .Values.podAnnotations -}}
    annotations: {{ toYaml .Values.podAnnotations | nindent 6 }}
    {{- end }}
    labels:
      app: {{ include "common.mariadbService" . }}
      version: {{ .Values.mariadbOperator.appVersion }}
  rootPasswordSecretKeyRef:
    name: {{ include "common.mariadb.secret.rootPassSecretName"
        (dict "dot" . "chartName" .Values.global.mariadbGalera.nameOverride) }}
    key: password
  image:
    repository: {{ include "repositoryGenerator.dockerHubRepository" . }}/{{ .Values.mariadbOperator.image }}
    tag: {{ .Values.mariadbOperator.appVersion }}
    pullPolicy: IfNotPresent
  imagePullSecrets:
    - name: {{ include "common.namespace" . }}-docker-registry-key
  port: 3306
  replicas: {{ .Values.replicaCount }}
  galera:
    enabled: {{ .Values.mariadbOperator.galera.enabled }}
    sst: mariabackup
    replicaThreads: 1
    agent:
      image:
        repository: {{ include "repositoryGenerator.githubContainerRegistry" . }}/{{ .Values.mariadbOperator.galera.agentImage }}
        tag: {{ .Values.mariadbOperator.galera.agentVersion }}
        pullPolicy: IfNotPresent
      port: 5555
      kubernetesAuth:
        enabled: true
        authDelegatorRoleName: {{ include "common.mariadbService" . }}-auth
      gracefulShutdownTimeout: 5s
    recovery:
      enabled: true
      clusterHealthyTimeout: 5m
      clusterBootstrapTimeout: 10m
      podRecoveryTimeout: 5m
      podSyncTimeout: 10m
    initContainer:
      image:
        repository: {{ include "repositoryGenerator.githubContainerRegistry" . }}/{{ .Values.mariadbOperator.galera.initImage }}
        tag: {{ .Values.mariadbOperator.galera.initVersion }}
        pullPolicy: IfNotPresent
    volumeClaimTemplate:
      resources:
        requests:
          storage: 50Mi
      accessModes:
        - ReadWriteOnce
  livenessProbe:
    exec:
      command:
        - bash
        - '-c'
        {{- if .Values.mariadbOperator.galera.enabled }}
        - >-
          mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "SHOW STATUS LIKE
          'wsrep_ready'" | grep -c ON
        {{- else }}
        - mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "SELECT 1;"
        {{- end }}
    initialDelaySeconds: 20
    periodSeconds: 10
    timeoutSeconds: 5
  readinessProbe:
    exec:
      command:
        - bash
        - '-c'
        {{- if .Values.mariadbOperator.galera.enabled }}
        - >-
          mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "SHOW STATUS LIKE
          'wsrep_ready'" | grep -c ON
        {{- else }}
        - mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "SELECT 1;"
        {{- end }}
    initialDelaySeconds: 20
    periodSeconds: 10
    timeoutSeconds: 5
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: kubernetes.io/hostname
  tolerations:
    - key: mariadb.mmontes.io/ha
      operator: Exists
      effect: NoSchedule
  podDisruptionBudget:
    maxUnavailable: 50%
  updateStrategy:
    type: RollingUpdate
  myCnf: |
    [mysqld]
    bind-address=0.0.0.0
    default_storage_engine=InnoDB
    binlog_format=row
    innodb_autoinc_lock_mode=2
    max_allowed_packet=256M
  #myCnfConfigMapKeyRef:
  #  key: my.cnf
  #  name: cds-mariadb
  resources: {{ include "common.resources" . | nindent 4 }}
  volumeClaimTemplate:
    {{- if .Values.mariadbOperator.storageClassName }}
    storageClassName: {{ .Values.k8ssandraOperator.persistence.storageClassName }}
    {{- end }}
    resources:
      requests:
        storage: {{ .Values.persistence.size | quote }}
    accessModes:
      - ReadWriteOnce
{{-  if .Values.db.name }}
{{ include "common.mariadbOpDatabase" (dict "dot" . "dbname" .Values.db.name "dbinst" $dbinst) }}
{{-  end }}
{{-  if .Values.db.user }}
{{ include "common.mariadbOpUser" (dict "dot" . "dbuser" .Values.db.user "dbinst" $dbinst "dbsecret" $dbusersecret) }}
{{-  end }}
{{- end -}}
