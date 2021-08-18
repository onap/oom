{{/*
# Copyright (C) 2021 Bell Canada.
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
  UID of timescaledb root password
*/}}
{{- define "common.timescaledb.secret.rootPassUID" -}}
  {{- printf "db-root-password" }}
{{- end -}}

{{/*
  Name of timescaledb secret
*/}}
{{- define "common.timescaledb.secret._secretName" -}}
  {{- $global := .dot }}
  {{- $chartName := tpl .chartName $global -}}
  {{- include "common.secret.genName" (dict "global" $global "uid" (include .uidTemplate $global) "chartName" $chartName) }}
{{- end -}}

{{/*
  Name of timescaledb root password secret
*/}}
{{- define "common.timescaledb.secret.rootPassSecretName" -}}
  {{- include "common.timescaledb.secret._secretName" (set . "uidTemplate" "common.timescaledb.secret.rootPassUID") }}
{{- end -}}

{{/*
  UID of timescaledb user credentials
*/}}
{{- define "common.timescaledb.secret.userCredentialsUID" -}}
  {{- printf "db-user-credentials" }}
{{- end -}}

{{/*
  Name of timescaledb user credentials secret
*/}}
{{- define "common.timescaledb.secret.userCredentialsSecretName" -}}
  {{- include "common.timescaledb.secret._secretName" (set . "uidTemplate" "common.timescaledb.secret.userCredentialsUID") }}
{{- end -}}

{{/*
  UID of timescaledb primary password
*/}}
{{- define "common.timescaledb.secret.primaryPasswordUID" -}}
  {{- printf "primary-password" }}
{{- end -}}

{{/*
  Name of timescaledb user credentials secret
*/}}
{{- define "common.timescaledb.secret.primaryPasswordSecretName" -}}
  {{- include "common.timescaledb.secret._secretName" (set . "uidTemplate" "common.timescaledb.secret.primaryPasswordUID") }}
{{- end -}}
