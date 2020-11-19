{{/*
# Copyright © 2017 Amdocs, Bell Canada
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
  Resolve the name of the common image repository.

  - .Values.global.repository  : default image repository for all ONAP images
  - .Values.repositoryOverride : override global repository on a per chart basis
*/}}
{{- define "repositoryGenerator.repository" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- if $dot.Values.repositoryOverride -}}
    {{- printf "%s" $dot.Values.repositoryOverride -}}
  {{- else -}}
    {{- default $initRoot.common.global.repository $dot.Values.global.repository -}}
  {{- end }}
{{- end -}}

{{/*
  Resolve the name of the dockerHub image repository.

  - .Values.global.dockerHubRepository  : default image dockerHubRepository for all dockerHub images
  - .Values.dockerHubRepositoryOverride : override global dockerHub repository on a per chart basis
*/}}
{{- define "repositoryGenerator.dockerHubRepository" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- if $dot.Values.dockerHubRepositoryOverride }}
    {{- printf "%s" $dot.Values.dockerHubRepositoryOverride -}}
  {{- else }}
    {{- default $initRoot.common.global.dockerHubRepository $dot.Values.global.dockerHubRepository -}}
  {{- end }}
{{- end -}}

{{/*
  Resolve the name of the elasticRepository image repository.

  - .Values.global.elasticRepository  : default image elasticRepository for all images using elastic repository
  - .Values.elasticRepositoryOverride : override global elasticRepository repository on a per chart basis
*/}}
{{- define "repositoryGenerator.elasticRepository" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- if $dot.Values.elasticRepositoryOverride }}
    {{- printf "%s" $dot.Values.elasticRepositoryOverride -}}
  {{- else }}
    {{- default $initRoot.common.global.elasticRepository $dot.Values.global.elasticRepository -}}
  {{- end }}
{{- end -}}

{{/*
  Resolve the name of the googleK8sRepository image repository.

  - .Values.global.googleK8sRepository  : default image dockerHubRepository for all dockerHub images
  - .Values.googleK8sRepositoryOverride : override global dockerHub repository on a per chart basis
*/}}
{{- define "repositoryGenerator.googleK8sRepository" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- if $dot.Values.googleK8sRepositoryOverride }}
    {{- printf "%s" $dot.Values.googleK8sRepositoryOverride -}}
  {{- else }}
    {{- default $initRoot.common.global.googleK8sRepository $dot.Values.global.googleK8sRepository -}}
  {{- end }}
{{- end -}}

{{- define "repositoryGenerator.image.busybox" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.busyboxImage $dot.Values.global.busyboxImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.curl" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.curlImage $dot.Values.global.curlImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.envsubst" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.envsubstImage $dot.Values.global.envsubstImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.htpasswd" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.htpasswdImage $dot.Values.global.htpasswdImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.kubectl" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.kubectlImage $dot.Values.global.kubectlImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.logging" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.elasticRepository" $dot }}/{{- default $initRoot.common.global.loggingImage $dot.Values.global.loggingImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.mariadb" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.mariadbImage $dot.Values.global.mariadbImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.nginx" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.nginxImage $dot.Values.global.nginxImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.postgres" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.dockerHubRepository" $dot }}/{{- default $initRoot.common.global.postgresImage $dot.Values.global.postgresImage -}}
{{- end -}}

{{- define "repositoryGenerator.image.readiness" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{- include "repositoryGenerator.repository" $dot }}/{{- default $initRoot.common.global.readinessImage $dot.Values.global.readinessImage -}}
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
*/}}
{{- define "repositoryGenerator.secret" -}}
  {{- $dot := default . .dot -}}
  {{- $initRoot := default $dot.Values.repositoryGenerator .initRoot -}}
  {{/* Our version of helm doesn't support deepCopy so we need this nasty trick */}}
  {{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
  {{- $repoCreds := "" }}
  {{- if $subchartDot.Values.global.dockerHubRepositoryCred }}
  {{-   $repo := $subchartDot.Values.global.repository }}
  {{-   $cred := $subchartDot.Values.global.repositoryCred }}
  {{-   $mail := default "@" $cred.mail }}
  {{-   $auth := printf "%s:%s" $cred.user $cred.password | b64enc }}
  {{-   $repoCreds = printf "\"%s\": {\"username\":\"%s\",\"password\":\"%s\",\"email\":\"%s\",\"auth\":\"%s\"}" $repo $cred.user $cred.password $mail $auth }}
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
  {{- printf "{%s}" $repoCreds | b64enc -}}
{{- end -}}