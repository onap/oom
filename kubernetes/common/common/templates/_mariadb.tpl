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
  Choose the name of the mariadb service to use.
*/}}
{{- define "common.mariadbService" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
    {{- index .Values "mariadb-galera" "service" "name" -}}
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
    {{ printf "%s-%s" (.Release.Name) (index .Values "mariadb-init" "nameOverride") -}}
  {{- end -}}
{{- end -}}

{{/*
  Choose the value of secret param to retrieve user value.
*/}}
{{- define "common.mariadbSecretParam" -}}
  {{- if .Values.global.mariadbGalera.localCluster -}}
    {{ printf "password" -}}
  {{- else -}}
    {{ printf "db-user-password" -}}
  {{- end -}}
{{- end -}}
