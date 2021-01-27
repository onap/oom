{{/*
# Copyright © 2021 Bitnami, Intel
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
Create the name of the service account to use
*/}}
{{- define "fluentd.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "common.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/* Check if there are rolling tags in the images */}}
{{- define "fluentd.checkRollingTags" -}}
{{- if and (contains "bitnami/" .Values.image) (not (.Values.image | toString | regexFind "-r\\d+$|sha256:")) }}
WARNING: Rolling tag detected ({{ .Values.image }}), please note that it is strongly recommended to avoid using rolling tags in a production environment.
+info https://docs.bitnami.com/containers/how-to/understand-rolling-tags-containers/
{{- end }}
{{- end -}}

{{/*
Validate data
*/}}
{{- define "fluentd.validateValues" -}}
{{- $messages := list -}}
{{- $messages := append $messages (include "fluentd.validateValues.deployment" .) -}}
{{- $messages := append $messages (include "fluentd.validateValues.rbac" .) -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}
 {{- if $message -}}
{{-   printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - forwarders and aggregators can't be disabled at the same time */}}
{{- define "fluentd.validateValues.deployment" -}}
{{- if and (not .Values.forwarder.enabled) (not .Values.aggregator.enabled) -}}
fluentd:
    You have disabled both the forwarders and the aggregators.
    Please enable at least one of them (--set forwarder.enabled=true) (--set aggregator.enabled=true)
{{- end -}}
{{- end -}}

{{/* Validate values of Fluentd - must create serviceAccount to create enable RBAC */}}
{{- define "fluentd.validateValues.rbac" -}}
{{- if and .Values.rbac.create (not .Values.serviceAccount.create) -}}
fluentd: rbac.create
    A ServiceAccount is required ("rbac.create=true" is set)
    Please create a ServiceAccount (--set serviceAccount.create=true)
{{- end -}}
{{- end -}}

{{/*
Get the forwarder configmap name.
*/}}
{{- define "fluentd.forwarder.configMap" -}}
{{- if .Values.forwarder.configMap -}}
    {{- printf "%s" (tpl .Values.forwarder.configMap $) -}}
{{- else -}}
    {{- printf "%s-forwarder-cm" (include "common.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the aggregator configmap name.
*/}}
{{- define "fluentd.aggregator.configMap" -}}
{{- if .Values.aggregator.configMap -}}
    {{- printf "%s" (tpl .Values.aggregator.configMap $) -}}
{{- else -}}
    {{- printf "%s-aggregator-cm" (include "common.fullname" . ) -}}
{{- end -}}
{{- end -}}

{{/*
Get the certificates secret name.
*/}}
{{- define "fluentd.tls.secretName" -}}
{{- if .Values.tls.existingSecret -}}
    {{- printf "%s" (tpl .Values.tls.existingSecret $) -}}
{{- else -}}
    {{- printf "%s-tls" (include "common.fullname" . ) -}}
{{- end -}}
{{- end -}}
