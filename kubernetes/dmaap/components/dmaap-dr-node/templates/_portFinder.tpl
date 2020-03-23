# Copyright © 2020 Samsung Electronics
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

{{- define "dmaap.dr.node.buildPortCache" -}}
  {{- $global := . }}
  {{- if not $global.Values._DmaapDrNodePortsCache }}
    {{- $portCache := dict }}
    {{- range $port := .Values.service.ports }}
      {{- $_ := set $portCache $port.name (dict "port" $port.port "plain_port" $port.plain_port) }}
    {{- end }}
    {{- $_ := set $global.Values "_DmaapDrNodePortsCache" $portCache }}
  {{- end }}
{{- end -}}

{/*
  Get Port value according to its name and if we want tls or plain port.
  The template takes below arguments:
    - .global: environment (.)
    - .name: name of the port
    - .getPlain: boolean allowing to choose between tls (false, default) or
                 plain (true)
    If plain_port is not set and we ask for plain, it will return empty.
*/}
{{- define "dmaap.dr.node.getPort" -}}
  {{- $global := .global }}
  {{- $name := .name }}
  {{- $getPlain := default false .getPlain }}
  {{- include "dmaap.dr.node.buildPortCache" $global }}
  {{- $portCache := $global.Values._DmaapDrNodePortsCache }}
  {{- $port := index $portCache $name }}
  {{- ternary $port.plain_port $port.port $getPlain }}
{{- end -}}
