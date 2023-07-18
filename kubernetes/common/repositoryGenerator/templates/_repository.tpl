{{/*
# Copyright © 2017 Amdocs, Bell Canada
# Copyright © 2021 AT&T
# Modifications Copyright (C) 2021 Nordix Foundation.
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

{{- define "repositoryGenerator._repositoryHelper" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- $repoName := .repoName }}
  {{- $overrideName := printf "%s%s" $repoName "Override" }}
  {{- if (hasKey $dot.Values $overrideName) -}}
    {{- printf "%s" (first (pluck $overrideName $dot.Values)) -}}
  {{- else -}}
    {{- first (pluck $repoName $dot.Values.global $initRoot.global) -}}
  {{- end }}
{{- end -}}

{{/*
  Resolve the name of the common image repository.

  - .Values.global.repository  : default image repository for all ONAP images
  - .Values.repositoryOverride : override global repository on a per chart basis
*/}}
{{- define "repositoryGenerator.repository" -}}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" "repository") .) }}
{{- end -}}

{{/*
  Resolve the name of the dockerHub image repository.

  - .Values.global.dockerHubRepository  : default image dockerHubRepository for all dockerHub images
  - .Values.dockerHubRepositoryOverride : override global dockerHub repository on a per chart basis
*/}}
{{- define "repositoryGenerator.dockerHubRepository" -}}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" "dockerHubRepository") .) }}
{{- end -}}

{{/*
  Resolve the name of the elasticRepository image repository.

  - .Values.global.elasticRepository  : default image elasticRepository for all images using elastic repository
  - .Values.elasticRepositoryOverride : override global elasticRepository repository on a per chart basis
*/}}
{{- define "repositoryGenerator.elasticRepository" -}}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" "elasticRepository") .) }}
{{- end -}}

{{/*
  Resolve the name of the quay.io Repository image repository.

  - .Values.global.quayRepository  : default image quayRepository for all images using quay repository
  - .Values.quayRepositoryOverride : override global quayRepository repository on a per chart basis
*/}}
{{- define "repositoryGenerator.quayRepository" -}}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" "quayRepository") .) }}
{{- end -}}

{{/*
  Resolve the name of the googleK8sRepository image repository.

  - .Values.global.googleK8sRepository  : default image dockerHubRepository for all dockerHub images
  - .Values.googleK8sRepositoryOverride : override global dockerHub repository on a per chart basis
*/}}
{{- define "repositoryGenerator.googleK8sRepository" -}}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" "googleK8sRepository") .) }}
{{- end -}}

{{/*
  Resolve the name of the GithubContainer registry
  - .Values.global.githubContainerRegistry  : default image githubContainerRegistry for all dockerHub images
  - .Values.githubContainerRegistryOverride : override global githubContainerRegistry on a per chart basis
*/}}
{{- define "repositoryGenerator.githubContainerRegistry" -}}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" "githubContainerRegistry") .) }}
{{- end -}}

{{- define "repositoryGenerator.image._helper" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- $image := .image }}
  {{- $repoName := first (pluck $image $initRoot.imageRepoMapping) }}
  {{- include "repositoryGenerator._repositoryHelper" (merge (dict "repoName" $repoName ) .) }}/{{- first (pluck $image $dot.Values.global $initRoot.global) -}}
{{- end -}}

{{- define "repositoryGenerator.image.busybox" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "busyboxImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.curl" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "curlImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.dcaepolicysync" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "dcaePolicySyncImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.envsubst" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "envsubstImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.htpasswd" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "htpasswdImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.jetty" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "jettyImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.jre" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "jreImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.kubectl" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "kubectlImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.logging" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "loggingImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.mariadb" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "mariadbImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.nginx" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "nginxImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.postgres" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "postgresImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.readiness" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "readinessImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.drProvClient" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "drProvClientImage") .) }}
{{- end -}}

{{- define "repositoryGenerator.image.quitQuit" -}}
  {{- include "repositoryGenerator.image._helper" (merge (dict "image" "quitQuitImage") .) }}
{{- end -}}

{{/*
  Resolve the image repository secret token.
  The value for .Values.global.repositoryCred is used if provided:
  repositoryCred:
    user: user
    password: password
    mail: email (optional)
  You can also set the same things for dockerHub, elastic and googleK8s if
  needed.
  if not needed, set global.repositoryCred.user to empty value.
*/}}
{{- define "repositoryGenerator.secret" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{/* Our version of helm doesn't support deepCopy so we need this nasty trick */}}
  {{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
  {{- $repoCreds := "" }}
  {{- if $subchartDot.Values.global.repositoryCred }}
  {{-   $repo := $subchartDot.Values.global.repository }}
  {{-   $cred := $subchartDot.Values.global.repositoryCred }}
  {{-   if $cred.user }}
  {{-     $mail := default "@" $cred.mail }}
  {{-     $auth := printf "%s:%s" $cred.user $cred.password | b64enc }}
  {{-     $repoCreds = printf "\"%s\": {\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}" $repo $cred.user $cred.password $mail $auth }}
  {{-   end }}
  {{- end }}
  {{- if $subchartDot.Values.global.dockerHubRepositoryCred }}
  {{-   $dhRepo := $subchartDot.Values.global.dockerHubRepository }}
  {{-   $dhCred := $subchartDot.Values.global.dockerHubRepositoryCred }}
  {{-   $dhMail := default "@" $dhCred.mail }}
  {{-   $dhAuth := printf "%s:%s" $dhCred.user $dhCred.password | b64enc }}
  {{-   $dhRepoCreds := printf "\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}" $dhRepo $dhCred.user $dhCred.password $dhMail $dhAuth }}
  {{-   if eq "" $repoCreds }}
  {{-     $repoCreds = $dhRepoCreds }}
  {{-   else }}
  {{-     $repoCreds = printf "%s, %s" $repoCreds $dhRepoCreds }}
  {{-   end }}
  {{- end }}
  {{- if $subchartDot.Values.global.elasticRepositoryCred }}
  {{-   $eRepo := $subchartDot.Values.global.elasticRepository }}
  {{-   $eCred := $subchartDot.Values.global.elasticRepositoryCred }}
  {{-   $eMail := default "@" $eCred.mail }}
  {{-   $eAuth := printf "%s:%s" $eCred.user $eCred.password | b64enc }}
  {{-   $eRepoCreds := printf "\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}" $eRepo $eCred.user $eCred.password $eMail $eAuth }}
  {{-   if eq "" $repoCreds }}
  {{-     $repoCreds = $eRepoCreds }}
  {{-   else }}
  {{-     $repoCreds = printf "%s, %s" $repoCreds $eRepoCreds }}
  {{-   end }}
  {{- end }}
  {{- if $subchartDot.Values.global.googleK8sRepositoryCred }}
  {{-   $gcrRepo := $subchartDot.Values.global.googleK8sRepository }}
  {{-   $gcrCred := $subchartDot.Values.global.googleK8sRepositoryCred }}
  {{-   $gcrMail := default "@" $gcrCred.mail }}
  {{-   $gcrAuth := printf "%s:%s" $gcrCred.user $gcrCred.password | b64enc }}
  {{-   $gcrRepoCreds := printf "\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}" $gcrRepo $gcrCred.user $gcrCred.password $gcrMail $gcrAuth }}
  {{-   if eq "" $repoCreds }}
  {{-     $repoCreds = $gcrRepoCreds }}
  {{-   else }}
  {{-     $repoCreds = printf "%s, %s" $repoCreds $gcrRepoCreds }}
  {{-   end }}
  {{- end }}
  {{- if $subchartDot.Values.global.githubContainerRegistryCred }}
  {{-   $ghcrRepo := $subchartDot.Values.global.githubContainerRegistry }}
  {{-   $ghcrCred := $subchartDot.Values.global.githubContainerRegistryCred }}
  {{-   $ghcrMail := default "@" $ghcrCred.mail }}
  {{-   $ghcrAuth := printf "%s:%s" $ghcrCred.user $ghcrCred.password | b64enc }}
  {{-   $ghcrRepoCreds := printf "\"%s\":{\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}" $ghcrRepo $ghcrCred.user $ghcrCred.password $ghcrMail $ghcrAuth }}
  {{-   if eq "" $repoCreds }}
  {{-     $repoCreds = $ghcrRepoCreds }}
  {{-   else }}
  {{-     $repoCreds = printf "%s, %s" $repoCreds $ghcrRepoCreds }}
  {{-   end }}
  {{- end }}
  {{- printf "{%s}" $repoCreds | b64enc -}}
{{- end -}}
