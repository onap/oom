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
  Resolve the master password to be used to derive other passwords. The value of
  .Values.masterPassword is used by default, unless either override mechanism is
  used:

  - .Values.global.masterPassword  : override default master password for all charts
  - .Values.masterPasswordOverride : override global and default masterPassword on a per chart basis
*/}}
{{- define "common.masterPassword" -}}
  {{ if .Values.masterPasswordOverride }}
    {{- printf "%s" .Values.masterPasswordOverride -}}
  {{ else if .Values.global.masterPassword }}
    {{- printf "%s" .Values.global.masterPassword -}}
  {{ else if .Values.masterPassword }}
    {{- printf "%s" .Values.masterPassword -}}
  {{ else if eq "testRelease" (include "common.release" .) }}
    {{/* Special case for chart liniting. DON"T NAME YOUR PRODUCTION RELEASE testRelease */}}
    {{- printf "testRelease" -}}
  {{ else if eq "test-release" .Release.Name }}
    {{/* Special case for chart linting in helm3. DON"T NAME YOUR PRODUCTION RELEASE test-release */}}
    {{- printf "testRelease" -}}
  {{ else }}
    {{ fail "masterPassword not provided" }}
  {{ end }}
{{- end -}}

{{- define "common._defaultPasswordStrength" -}}
  {{ if .Values.passwordStrengthOverride }}
    {{- printf "%s" .Values.passwordStrengthOverride -}}
  {{ else if .Values.global.passwordStrength }}
    {{- printf "%s" .Values.global.passwordStrength -}}
  {{ else if .Values.passwordStrength }}
    {{- printf "%s" .Values.passwordStrength -}}
  {{ else }}
    {{- printf "long" }}
  {{ end }}
{{- end -}}

{{/*
  Generate a new password based on masterPassword. The new password is not
  random, it is derived from masterPassword, fully qualified chart name and
  additional uid provided by the user. This ensures that every time when we
  run this function from the same place, with the same password and uid we
  get the same results. This allows to avoid password changes while you are
  doing upgrade.

  The function can take from one to three arguments (inside a dictionary):
  - .dot : environment (.)
  - .uid : unique identifier of password to be generated within this particular chart. Use only when you create more than a single password within one chart
  - .strength : complexity of derived password. See derivePassword documentation for more details

  Example calls:

    {{ include "common.createPassword" . }}
    {{ include "common.createPassword" (dict "dot" . "uid" "mysqlRootPasswd") }}

*/}}
{{- define "common.createPassword" -}}
  {{- $dot := default . .dot -}}
  {{- $uid := default "onap" .uid -}}
  {{- $defaultStrength := include "common._defaultPasswordStrength" $dot | trim -}}
  {{- $strength := default $defaultStrength .strength -}}
  {{- $mp := include "common.masterPassword" $dot -}}
  {{- derivePassword 1 $strength $mp (include "common.fullname" $dot) $uid -}}
{{- end -}}
