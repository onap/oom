{{/*
# Copyright © 2020 Orange
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
  Generate readiness part for a pod
  Will look by default to .Values.wait_for
  There are two formats available.

  The simple one (where wait_for is just list of containers):

  wait_for:
    - aaf-locate
    - aaf-cm
    - aaf-service

  The powerful one (where wait_for is a map):

  wait_for:
    name: myname
    containers:
      - aaf-locate
      - aaf-cm
      - aaf-service

  the powerful one allows also to wait for pod names with this
  (has to start with the given pod name):
  wait_for:
    name: myname
    pods:
      - test-pod

  the powerful one allows also to wait for pods with the
  given "app" label:
  wait_for:
    name: myname
    apps:
      - mariadb-galera

  the powerful one allows also to wait for jobs with this:
  wait_for:
    name: myname
    jobs:
      - '{{ include "common.release" . }}-the-job'

  Be careful, as on the example above, the job name may have a "non fixed" name
  and thus don't forget to use templates if needed

  The function can takes below arguments (inside a dictionary):
     - .dot : environment (.)
     - .initRoot : the root dictionary of readinessCheck submodule
                   (default to .Values.readinessCheck)
     - .wait_for : list of containers / pods /apps / jobs to wait for (default to
                   .Values.wait_for)

  Example calls:
    {{ include "common.readinessCheck.waitFor" . }}
    {{ include "common.readinessCheck.waitFor" (dict "dot" . "wait_for" .Values.where.my.wait_for.is ) }}
*/}}
{{- define "common.readinessCheck.waitFor" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.readinessCheck .initRoot -}}
{{/*  Our version of helm doesn't support deepCopy so we need this nasty trick */}}
{{-   $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{-   $wait_for := default $initRoot.wait_for .wait_for -}}
{{-   $containers := index (ternary (dict "containers" $wait_for) $wait_for (kindIs "slice" $wait_for)) "containers" -}}
{{-   $pods := index (ternary (dict "pods" $wait_for) $wait_for (kindIs "slice" $wait_for)) "pods" -}}
{{-   $apps := index (ternary (dict "apps" $wait_for) $wait_for (kindIs "slice" $wait_for)) "apps" -}}
{{-   $namePart := index (ternary (dict) $wait_for (kindIs "slice" $wait_for)) "name" -}}
{{-   $jobs := index (ternary (dict) $wait_for (kindIs "slice" $wait_for)) "jobs" -}}
- name: {{ include "common.name" $dot }}{{ ternary "" (printf "-%s" $namePart) (empty $namePart) }}-readiness
  image: {{ include "repositoryGenerator.image.readiness" $subchartDot }}
  imagePullPolicy: {{ $subchartDot.Values.global.pullPolicy | default $subchartDot.Values.pullPolicy }}
  securityContext:
    runAsUser: {{ $subchartDot.Values.user }}
    runAsGroup: {{ $subchartDot.Values.group }}
  command:
  - /app/ready.py
  args:
  {{- range $container := default (list) $containers }}
  - --container-name
  - {{ tpl $container $dot }}
  {{- end }}
  {{- range $pod := default (list) $pods }}
  - --pod-name
  - {{ tpl $pod $dot }}
  {{- end }}
  {{- range $app := default (list) $apps }}
  - --app-name
  - {{ tpl $app $dot }}
  {{- end }}
  {{- range $job := $jobs }}
  - --job-name
  - {{ tpl $job $dot }}
  {{- end }}
  env:
  - name: NAMESPACE
  {{- if $subchartDot.Values.namespace }}
    value: {{ $subchartDot.Values.namespace }}
  {{- else }}
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  {{- end }}
  resources:
    limits:
      cpu: {{ $subchartDot.Values.limits.cpu }}
      memory: {{ $subchartDot.Values.limits.memory }}
    requests:
      cpu: {{ $subchartDot.Values.requests.cpu }}
      memory: {{ $subchartDot.Values.requests.memory }}
{{- end -}}
