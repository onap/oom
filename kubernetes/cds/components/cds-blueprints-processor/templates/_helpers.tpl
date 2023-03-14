{{/*
# Copyright (c) 2023 Deutsche Telekom
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

{{- define "cds.customizableService" -}}
{{-   $dot := default . .dot -}}
{{-   $suffix := default "" .suffix -}}
{{-   $annotations := default "" .annotations -}}
{{-   $publishNotReadyAddresses := default false .publishNotReadyAddresses -}}
{{-   $msb_informations := default "" .msb -}}
{{-   $serviceType := .type -}}
{{-   $ports := .ports -}}
{{-   $both_tls_and_plain:= default false .both_tls_and_plain }}
{{-   $labels := default (dict) .labels -}}
{{-   $matchLabels := default (dict) .matchLabels -}}
{{-   if and (include "common.onServiceMesh" $dot) (eq $serviceType "NodePort") }}
{{-     $serviceType = "ClusterIP" }}
{{-   end }}

{{-   if (and (include "common.needTLS" $dot) $both_tls_and_plain) }}
{{      include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "msb_informations" $msb_informations "dot" $dot "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" "ClusterIP" "add_plain_port" true $labels "matchLabels" $matchLabels) }}
{{-     if (ne $serviceType "ClusterIP") }}
---
{{-       if $suffix }}
{{-         $suffix = printf "%s-external" $suffix }}
{{-       else }}
{{-         $suffix = "external" }}
{{-       end }}
{{        include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" $dot "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" $serviceType $labels "matchLabels" $matchLabels) }}
{{-     end }}
{{-   else }}
{{      include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" $dot "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" $serviceType $labels "matchLabels" $matchLabels) }}
{{-   end }}
{{- end -}}