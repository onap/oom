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
  Generate the container port list.
  Will use first ".Values.service.ports" list.
  Will append ports from ".Values.service.headlessPorts" only if port number is
  not already in port list.
  Will add tls port AND plain port if both_tls_and_plain is set to true
*/}}
{{- define "common.containerPorts" -}}
{{-   $ports := default (list) .Values.service.ports }}
{{-   $portsNumber := list }}
{{-   $both_tls_and_plain:= default false .Values.service.both_tls_and_plain }}
{{-   range $index, $port := $ports }}
{{-     $portsNumber = append $portsNumber $port.port }}
{{-   end }}
{{-   range $index, $port := .Values.service.headlessPorts }}
{{-     if not (has $port.port $portsNumber) }}
{{-       $ports = append $ports $port }}
{{-     end }}
{{-   end }}
{{- $global := . }}
{{-   range $index, $port := $ports }}
{{-     if (include "common.needTLS" $global) }}
- containerPort: {{ $port.port }}
{{-     else }}
- containerPort: {{ default $port.port $port.plain_port }}
{{-     end }}
  name: {{ $port.name }}
{{-     if (and $port.plain_port (and (include "common.needTLS" $global) $both_tls_and_plain))  }}
- containerPort: {{ $port.plain_port }}
  name: {{ $port.name }}-plain
{{-     end }}
{{-   end }}
{{- end -}}


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
    {{ include "common.waitForReadiness" . }}
    {{ include "common.waitForReadiness" (dict "dot" . "wait_for" .Values.where.my.wait_for.is ) }}
*/}}
{{- define "common.waitForReadiness" -}}
{{-   $dot := default . .dot -}}
{{-   $wait_for := default $dot.Values.wait_for .wait_for -}}
- name: {{ include "common.name" $dot }}-readiness
  image: "{{ $dot.Values.global.readinessRepository }}/{{ $dot.Values.global.readinessImage }}"
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  command:
  - /root/ready.py
  args:
  {{- range $container := $wait_for }}
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
      cpu: 100m
      memory: 100Mi
    requests:
      cpu: 3m
      memory: 20Mi
{{- end -}}

{{/*
   Generate securityContext for pod
*/}}
{{- define "common.securityContext" -}}
securityContext:
  runAsUser: {{ .Values.securityContext.user_id }}
  runAsGroup: {{ .Values.securityContext.group_id }}
  fsGroup: {{ .Values.securityContext.group_id }}
{{- end }}
