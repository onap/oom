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
- containerPort: {{ default $port.port $port.internal_port }}
{{-     else }}
- containerPort: {{ default (default $port.port $port.internal_port) (default $port.plain_port $port.internal_plain_port) }}
{{-     end }}
  name: {{ $port.name }}
{{-     if (and $port.plain_port (and (include "common.needTLS" $global) $both_tls_and_plain))  }}
- containerPort: {{ default $port.plain_port $port.internal_plain_port }}
  name: {{ $port.name }}-plain
{{-     end }}
{{-     if $port.l4_protocol }}
  protocol: {{ $port.l4_protocol }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/*
   Generate securityContext for pod
*/}}
{{- define "common.podSecurityContext" -}}
securityContext:
  runAsUser: {{ .Values.securityContext.user_id }}
  runAsGroup: {{ .Values.securityContext.group_id }}
  fsGroup: {{ .Values.securityContext.group_id }}
{{- end }}

{{/*
   Generate securityContext for container
*/}}
{{- define "common.containerSecurityContext" -}}
securityContext:
  readOnlyRootFilesystem: true
  privileged: false
  allowPrivilegeEscalation: false
{{- end }}
