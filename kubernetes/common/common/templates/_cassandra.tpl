{{/*
# Copyright © 2021 Orange
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
  UID of cassandra root password
*/}}
{{- define "common.cassandra.secret.rootPassUID" -}}
  {{- printf "db-root-password" }}
{{- end -}}

{{/*
  Name of cassandra secret
*/}}
{{- define "common.cassandra.secret._secretName" -}}
  {{- $global := .dot }}
  {{- $chartName := tpl .chartName $global -}}
  {{- include "common.secret.genName" (dict "global" $global "uid" (include .uidTemplate $global) "chartName" $chartName) }}
{{- end -}}

{{/*
  Name of cassandra root password secret
*/}}
{{- define "common.cassandra.secret.rootPassSecretName" -}}
  {{- include "common.cassandra.secret._secretName" (set . "uidTemplate" "common.cassandra.secret.rootPassUID") }}
{{- end -}}

{{/*
  UID of cassandra user credentials
*/}}
{{- define "common.cassandra.secret.userCredentialsUID" -}}
  {{- printf "db-user-credentials" }}
{{- end -}}

{{/*
  UID of cassandra backup credentials
*/}}
{{- define "common.cassandra.secret.backupCredentialsUID" -}}
  {{- printf "db-backup-credentials" }}
{{- end -}}

{{/*
  Name of cassandra user credentials secret
*/}}
{{- define "common.cassandra.secret.userCredentialsSecretName" -}}
  {{- include "common.cassandra.secret._secretName" (set . "uidTemplate" "common.cassandra.secret.userCredentialsUID") }}
{{- end -}}

{{/*
  Choose the name of the cassandra service to use.
*/}}
{{- define "common.cassandraService" -}}
  {{- if .Values.global.cassandra.localCluster -}}
    {{- index .Values "cassandra" "nameOverride" -}}
  {{- else -}}
    {{- .Values.global.cassandra.service -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of cassandra port to use.
*/}}
{{- define "common.cassandraPort" -}}
  {{- if .Values.global.cassandra.localCluster -}}
    {{- index .Values "cassandra" "service" "internalPort" -}}
  {{- else -}}
    {{- .Values.global.cassandra.internalPort -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of secret to retrieve user value.
*/}}
{{- define "common.cassandraSecret" -}}
  {{- if .Values.global.cassandra.localCluster -}}
    {{ printf "%s-%s-db-user-credentials" (include "common.fullname" .) (index .Values "cassandra" "nameOverride") -}}
  {{- else -}}
    {{ printf "%s-%s-%s" ( include "common.release" .) (index .Values "cassandra-init" "nameOverride") (index .Values "cassandra-init" "config" "mykeyspace" ) -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of secret param to retrieve user value.
*/}}
{{- define "common.cassandraSecretParam" -}}
  {{ printf "password" -}}
{{- end -}}
