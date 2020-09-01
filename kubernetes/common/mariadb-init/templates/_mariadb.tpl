{{/*
# Copyright © 2019 Orange
# Copyright © 2020 Samsung Electronics
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
  Choose the name of the mariadb secret to use.
*/}}
{{- define "mariadbInit.mariadbClusterSecret" -}}
  {{- include "common.mariadb.secret.rootPassSecretName" (dict "dot" . "chartName" (default "mariadb-galera" .Values.global.mariadbGalera.nameOverride)) -}}
{{- end -}}

{{- define "mariadbInit._updateSecrets" -}}
  {{- if not .Values.secretsUpdated }}
    {{- $global := . }}
    {{- range $db, $dbInfos := .Values.config.mysqlAdditionalDatabases }}
      {{- $item := dict "uid" $db "type" "basicAuth" "externalSecret" (default "" $dbInfos.externalSecret) "login" (default "" $dbInfos.user) "password" (default "" $dbInfos.password) "passwordPolicy" "required" }}
      {{- $newList := append $global.Values.secrets $item }}
      {{- $_ := set $global.Values "secrets" $newList }}
    {{- end -}}
    {{ $_ := set $global.Values "secretsUpdated" true }}
  {{- end -}}
{{- end -}}
