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

  Value of wait_for is an array of all pods /jobs to wait:

  Example:

  wait_for:
    - aaf-locate
    - aaf-cm
    - aaf-service

  The function can takes two arguments (inside a dictionary):
     - .dot : environment (.)
     - .wait_for : list of containers / jobs to wait for (default to
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
- name: {{ include "common.name" $dot }}-{{ $wait_for.name }}-readiness
  image: "{{ $subchartDot.Values.global.readinessRepository }}/{{ $subchartDot.Values.global.readinessImage }}"
  imagePullPolicy: {{ $subchartDot.Values.global.pullPolicy | default $subchartDot.Values.pullPolicy }}
  command:
  - /root/ready.py
  args:
  {{- range $container := $wait_for.containers }}
  - --container-name
  - {{ tpl $container $dot }}
  {{- end }}
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  resources:
    limits:
      cpu: {{ $subchartDot.Values.limits.cpu }}
      memory: {{ $subchartDot.Values.limits.memory }}
    requests:
      cpu: {{ $subchartDot.Values.requests.cpu }}
      memory: {{ $subchartDot.Values.requests.memory }}
{{- end -}}
