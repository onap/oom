# Copyright © 2020 Bitnami
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
{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}

{{/* TODO
Return the proper ES image name
*/}}
{{- define "elasticsearch.image" -}}
{{- $registryName := .Values.image.registry -}}
{{- $repositoryName := .Values.image.repository -}}
{{- $tag := .Values.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified master name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.master.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.master.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified ingest name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.ingest.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.ingest.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified discovery name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.discovery.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.discovery.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified coordinating name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.coordinating.fullname" -}}
{{- if .Values.global.kibanaEnabled -}}
{{- printf "%s-%s" .Release.Name .Values.global.coordinating.name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.global.coordinating.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified data name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.data.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.data.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
 Create the name of the master service account to use
 */}}
{{- define "elasticsearch.master.serviceAccountName" -}}
{{- if .Values.master.serviceAccount.create -}}
    {{ default (include "elasticsearch.master.fullname" .) .Values.master.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.master.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the coordinating-only service account to use
 */}}
{{- define "elasticsearch.coordinating.serviceAccountName" -}}
{{- if .Values.coordinating.serviceAccount.create -}}
    {{ default (include "elasticsearch.coordinating.fullname" .) .Values.coordinating.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.coordinating.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
 Create the name of the data service account to use
 */}}
{{- define "elasticsearch.data.serviceAccountName" -}}
{{- if .Values.data.serviceAccount.create -}}
    {{ default (include "elasticsearch.data.fullname" .) .Values.data.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.data.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create a default fully qualified metrics name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "elasticsearch.metrics.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.metrics.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Return the proper ES exporter image name
*/}}
{{- define "elasticsearch.metrics.image" -}}
{{- $registryName := .Values.metrics.image.registry -}}
{{- $repositoryName := .Values.metrics.image.repository -}}
{{- $tag := .Values.metrics.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper sysctl image name
*/}}
{{- define "elasticsearch.sysctl.image" -}}
{{- $registryName := .Values.sysctlImage.registry -}}
{{- $repositoryName := .Values.sysctlImage.repository -}}
{{- $tag := .Values.sysctlImage.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "elasticsearch.imagePullSecrets" -}}
{{- if .Values.global }}
{{- if .Values.global.imagePullSecrets }}
imagePullSecrets:
{{- range .Values.global.imagePullSecrets }}
  - name: {{ . }}
{{- end }}
{{- end }}
{{- else }}
{{- $imagePullSecrets := coalesce .Values.image.pullSecrets .Values.metrics.image.pullSecrets .Values.curator.image.pullSecrets .Values.sysctlImage.pullSecrets .Values.volumePermissions.image.pullSecrets -}}
{{- if $imagePullSecrets }}
imagePullSecrets:
{{- range $imagePullSecrets }}
  - name: {{ . }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "elasticsearch.volumePermissions.image" -}}
{{- $registryName := .Values.volumePermissions.image.registry -}}
{{- $repositoryName := .Values.volumePermissions.image.repository -}}
{{- $tag := .Values.volumePermissions.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "elasticsearch.data.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.data.persistence.storageClass -}}
              {{- if (eq "-" .Values.data.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.data.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.data.persistence.storageClass -}}
        {{- if (eq "-" .Values.data.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.data.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}

{{/*
Expand the name of the chart.
*/}}
{{- define "elasticsearch.curator.name" -}}
{{- include "common.name" | trunc 63 | trimSuffix "-" -}}-curator
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "elasticsearch.curator.fullname" -}}
{{- printf "%s-%s" (include "common.fullname" .) .Values.curator.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "elasticsearch.curator.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create the name of the service account to use
*/}}
{{- define "elasticsearch.curator.serviceAccountName" -}}
{{- if .Values.curator.serviceAccount.create -}}
    {{ default (include "elasticsearch.curator.fullname" .) .Values.curator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.curator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the proper ES curator image name
*/}}
{{- define "elasticsearch.curator.image" -}}
{{- $registryName := .Values.curator.image.registry -}}
{{- $repositoryName := .Values.curator.image.repository -}}
{{- $tag := .Values.curator.image.tag | toString -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 doesn't support it, so we need to implement this if-else logic.
Also, we can't use a single if because lazy evaluation is not an option
*/}}
{{- if .Values.global }}
    {{- if .Values.global.imageRegistry }}
        {{- printf "%s/%s:%s" .Values.global.imageRegistry $repositoryName $tag -}}
    {{- else -}}
        {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
    {{- end -}}
{{- else -}}
    {{- printf "%s/%s:%s" $registryName $repositoryName $tag -}}
{{- end -}}
{{- end -}}

{{/*
Renders a value that contains template.
Usage:
{{ include "common.tplValue" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "common.tplValue" -}}
    {{- if typeIs "string" .value }}
        {{- tpl .value .context }}
    {{- else }}
        {{- tpl (.value | toYaml) .context }}
    {{- end }}
{{- end -}}
