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
  Choose the name of the mariadb app label to use.
*/}}
{{- define "common.mariadbAppName" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
    {{- index .Values "mariadb-galera" "nameOverride" -}}
  {{- else -}}
    {{- .Values.global.mariadbGalera.nameOverride -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the name of the mariadb service to use.
*/}}
{{- define "common.mariadbService" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
  {{-   if and .Values.global.mariadbGalera.useOperator  (index .Values "mariadb-galera" "mariadbOperator" "galera" "enabled") }}
    {{- printf "%s-primary" (index .Values "mariadb-galera" "nameOverride") -}}
  {{-   else }}
    {{- index .Values "mariadb-galera" "nameOverride" -}}
  {{-   end }}
  {{- else -}}
  {{-   if .Values.global.mariadbGalera.useOperator }}
    {{- printf "%s-primary" (.Values.global.mariadbGalera.service) }}
  {{-   else }}
    {{- .Values.global.mariadbGalera.service -}}
  {{-   end }}
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
  name: {{ $dbinst }}-{{ $dbname }}
spec:
  name: {{ $dbname }}
  mariaDbRef:
    name: {{ $dbinst }}
  characterSet: utf8
  collate: utf8_general_ci
  retryInterval: 5s
{{- end -}}

{{/*
  Create MariaDB User via mariadb-operator
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
  name: {{ $dbinst }}-{{ $dbuser }}
spec:
  name: {{ $dbuser }}
  mariaDbRef:
    name: {{ $dbinst }}
  passwordSecretKeyRef:
    name: {{ $dbsecret }}
    key: password
  # This field is immutable and defaults to 10
  maxUserConnections: 100
  retryInterval: 5s
{{- end -}}

{{/*
  Grant rights to a MariaDB User via mariadb-operator
*/}}
{{- define "common.mariadbOpGrants" -}}
{{- $dot := default . .dot -}}
{{- $dbuser := (required "'dbuser' param, is required." .dbuser) -}}
{{- $dbname := (required "'dbame' param, is required." .dbname) -}}
{{- $dbinst := (required "'dbinst' param, is required." .dbinst) -}}
---
apiVersion: mariadb.mmontes.io/v1alpha1
kind: Grant
metadata:
  name: {{ $dbuser }}-{{ $dbname }}-{{ $dbinst }}
spec:
  mariaDbRef:
    name: {{ $dbinst }}
  privileges:
    - "ALL"
  database: {{ $dbname }}
  table: "*"
  username: {{ $dbuser }}
  retryInterval: 5s
  grantOption: true
{{- end -}}

{{/*
  MariaDB Backup via mariadb-operator
*/}}
{{- define "common.mariadbOpBackup" -}}
{{- $dot := default . .dot -}}
{{- $dbinst := include "common.name" $dot -}}
{{- $name := default $dbinst $dot.Values.backup.nameOverride -}}
---
apiVersion: mariadb.mmontes.io/v1alpha1
kind: Backup
metadata:
  name: {{ $name }}
spec:
  mariaDbRef:
    name: {{ $dbinst }}
  schedule:
    cron: {{ $dot.Values.backup.cron }}
    suspend: false
  maxRetention: {{ $dot.Values.backup.maxRetention }}
  storage:
    {{- if eq $dot.Values.backup.storageType "PVC" }}
    persistentVolumeClaim:
      resources:
        requests:
          storage: {{ $dot.Values.backup.persistence.size }}
      {{- if $dot.Values.mariadbOperator.storageClassName }}
      storageClassName: {{ $dot.Values.mariadbOperator.storageClassName }}
      {{- end }}
      accessModes:
        - {{ $dot.Values.backup.persistence.accessMode }}
    {{- end }}
    {{- if eq $dot.Values.backup.storageType "S3" }}
    s3: {{- include "common.tplValue" ( dict "value" .Values.backup.s3 "context" $) | nindent 6 }}
    {{- end }}
    {{- if eq $dot.Values.backup.storageType "volume" }}
    volume: {{- include "common.tplValue" ( dict "value" .Values.backup.volume "context" $) | nindent 6 }}
    {{- end }}
  resources:
    requests:
      cpu: "100m"
      memory: "100Mi"
    limits:
      cpu: "300m"
      memory: "500Mi"
{{- end -}}

{{/*
  Create a MariaDB instance via mariadb-operator
*/}}
{{- define "common.mariadbOpInstance" -}}
{{- $dot := default . .dot -}}
{{- $global := $dot.Values.global -}}
{{- $dbinst := include "common.name" $dot -}}
{{- $dbrootsecret := tpl (default (include "common.mariadb.secret.rootPassSecretName" (dict "dot" $dot "chartName" "")) $dot.Values.rootUser.externalSecret) $dot -}}
{{- $dbusersecret := tpl (default (include "common.mariadb.secret.userCredentialsSecretName" (dict "dot" $dot "chartName" "")) $dot.Values.db.externalSecret) $dot -}}
---
apiVersion: mariadb.mmontes.io/v1alpha1
kind: MariaDB
metadata:
  name: {{ $dbinst }}
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
      app: {{ $dbinst }}
      version: {{ .Values.mariadbOperator.appVersion }}
  rootPasswordSecretKeyRef:
    name: {{ $dbrootsecret }}
    key: password
  image: {{ include "repositoryGenerator.dockerHubRepository" . }}/{{ .Values.mariadbOperator.image }}:{{ $dot.Values.mariadbOperator.appVersion }}
  imagePullPolicy: IfNotPresent
  {{- include "common.imagePullSecrets" . | nindent 2 }}
  port: 3306
  replicas: {{ $dot.Values.replicaCount }}
  {{- if $dot.Values.mariadbOperator.galera.enabled }}
  galera:
    enabled: true
    sst: mariabackup
    replicaThreads: 1
    agent:
      image: {{ include "repositoryGenerator.githubContainerRegistry" . }}/{{ .Values.mariadbOperator.galera.agentImage }}:{{ $dot.Values.mariadbOperator.galera.agentVersion }}
      imagePullPolicy: IfNotPresent
      port: 5555
      kubernetesAuth:
        enabled: true
        authDelegatorRoleName: {{ $dbinst }}-auth
      gracefulShutdownTimeout: 5s
    recovery:
      enabled: true
      clusterHealthyTimeout: 5m0s
      clusterBootstrapTimeout: 10m0s
      podRecoveryTimeout: 5m0s
      podSyncTimeout: 10m0s
    initContainer:
      image: {{ include "repositoryGenerator.githubContainerRegistry" . }}/{{ $dot.Values.mariadbOperator.galera.initImage }}:{{ $dot.Values.mariadbOperator.galera.initVersion }}
      imagePullPolicy: IfNotPresent
    volumeClaimTemplate:
      {{- if .Values.mariadbOperator.storageClassName }}
      storageClassName: {{ .Values.mariadbOperator.storageClassName }}
      {{- end }}
      resources:
        requests:
          storage: 50Mi
      accessModes:
        - ReadWriteOnce
  {{- end }}
  livenessProbe:
    exec:
      command:
        - bash
        - '-c'
        - mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "SELECT 1;"
    initialDelaySeconds: 20
    periodSeconds: 10
    timeoutSeconds: 5
  readinessProbe:
    exec:
      command:
        - bash
        - '-c'
        - mariadb -u root -p"${MARIADB_ROOT_PASSWORD}" -e "SELECT 1;"
    initialDelaySeconds: 20
    periodSeconds: 10
    timeoutSeconds: 5
  {{- if default false .Values.global.metrics.enabled }}
  metrics:
    enabled: true
  {{- end }}
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

  myCnfConfigMapKeyRef:
    key: my.cnf
    name: {{ printf "%s-configuration" (include "common.fullname" $dot) }}
  resources: {{ include "common.resources" . | nindent 4 }}
  volumeClaimTemplate:
    {{- if $dot.Values.mariadbOperator.storageClassName }}
    storageClassName: {{ $dot.Values.mariadbOperator.storageClassName }}
    {{- end }}
    resources:
      requests:
        storage: {{ $dot.Values.mariadbOperator.persistence.size | quote }}
    accessModes:
      - ReadWriteOnce
{{-  if $dot.Values.db.user }}
{{ include "common.mariadbOpUser" (dict "dot" . "dbuser" $dot.Values.db.user "dbinst" $dbinst "dbsecret" $dbusersecret) }}
{{-  end }}
{{-  if $dot.Values.db.name }}
{{ include "common.mariadbOpDatabase" (dict "dot" . "dbname" $dot.Values.db.name "dbinst" $dbinst) }}
{{-  end }}
{{-  if and $dot.Values.db.user $dot.Values.db.name }}
{{ include "common.mariadbOpGrants" (dict "dot" . "dbuser" $dot.Values.db.user "dbname" $dot.Values.db.name "dbinst" $dbinst) }}
{{-  end }}
{{- end -}}
