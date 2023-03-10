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
  Resolve the name of a chart's service.

  The default will be the chart name (or .Values.nameOverride if set).
  And the use of .Values.service.name overrides all.

  - .Values.service.name: override default service (ie. chart) name
*/}}
{{/*
  Expand the service name for a chart.
*/}}
{{- define "common.servicename" -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- default $name .Values.service.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Resolve the prefix node port to use. We look at these different values in
  order of priority (first found, first chosen)
  - .Values.service.nodePortPrefixOverride: override value for nodePort which
                                            will be use locally;
  - .Values.global.nodePortPrefix         : global value for nodePort which will
                                            be used for all charts (unless
                                            previous one is used);
  - .Values.global.nodePortPrefixExt      : global value for nodePort which will
                                            be used for all charts (unless
                                            previous one is used) if
                                            useNodePortExt is set to true in
                                            service or on port;
  - .Values.service.nodePortPrefix        : value used on a pert chart basis if
                                            no other version exists.

  The function takes two arguments (inside a dictionary):
     - .dot : environment (.)
     - .useNodePortExt : does the port use the "extended" nodeport part or the
                         normal one?
*/}}
{{- define "common.nodePortPrefix" -}}
{{-   $dot := default . .dot -}}
{{-   $useNodePortExt := default false .useNodePortExt -}}
{{-   if or $useNodePortExt $dot.Values.service.useNodePortExt -}}
{{      $dot.Values.service.nodePortPrefixOverride | default $dot.Values.global.nodePortPrefixExt | default $dot.Values.nodePortPrefix }}
{{-   else -}}
{{      $dot.Values.service.nodePortPrefixOverride | default $dot.Values.global.nodePortPrefix | default $dot.Values.nodePortPrefix }}
{{-   end -}}
{{- end -}}

{{/* Define the metadata of Service
     The function takes from one to four arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : a string which will be added at the end of the name (with a '-').
     - .annotations: the annotations to add
     - .msb_informations: msb information in order to create msb annotation
     - .labels : labels to add
     Usage example:
      {{ include "common.serviceMetadata" ( dict "suffix" "myService" "dot" .) }}
      {{ include "common.serviceMetadata" ( dict "annotations" .Values.service.annotation "dot" .) }}
*/}}
{{- define "common.serviceMetadata" -}}
  {{- $dot := default . .dot -}}
  {{- $suffix := default "" .suffix -}}
  {{- $annotations := default "" .annotations -}}
  {{- $msb_informations := default "" .msb_informations -}}
  {{- $labels := default (dict) .labels -}}
{{- if or $annotations $msb_informations -}}
annotations:
{{-   if $annotations }}
{{      include "common.tplValue" (dict "value" $annotations "context" $dot) | indent 2 }}
{{-   end }}
{{-   if $msb_informations }}
  msb.onap.org/service-info: '[
{{-     range $index, $msb_information := $msb_informations }}
{{-       if ne $index 0 }}
      ,
{{-       end }}
      {
        "serviceName": "{{ default (include "common.servicename" $dot) $msb_information.serviceName  }}",
        "version": "{{ default "v1" $msb_information.version }}",
        "url": "{{ default "/" $msb_information.url }}",
        "protocol": "{{ default "REST" $msb_information.protocol }}",
        "enable_ssl": {{ default false $msb_information.enable_ssl }},
        "port": "{{ $msb_information.port }}",
        "visualRange":"{{ default "1" $msb_information.visualRange }}"
      }
{{-    end }}
    ]'
{{-   end}}
{{- end }}
name: {{ include "common.servicename" $dot }}{{ if $suffix }}{{ print "-" $suffix }}{{ end }}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" (dict "labels" $labels "dot" $dot) | nindent 2 -}}
{{- end -}}

{{/* Define the ports of Service
     The function takes three arguments (inside a dictionary):
     - .dot : environment (.)
     - .ports : an array of ports
     - .serviceType: the type of the service
     - .add_plain_port: add tls port AND plain port
*/}}
{{- define "common.servicePorts" -}}
{{- $serviceType := .serviceType }}
{{- $dot := .dot }}
{{- $add_plain_port := default false .add_plain_port }}
{{-   range $index, $port := .ports }}
{{-     if (include "common.needTLS" $dot) }}
- port: {{ $port.port }}
  targetPort: {{ $port.name }}
{{-       if $port.l4_protocol }}
  protocol: {{ $port.l4_protocol }}
{{-       else }}
  protocol: TCP
{{-       end }}
{{-       if $port.app_protocol }}
  appProtocol: {{ $port.app_protocol }}
{{-       end }}
{{-       if $port.port_protocol }}
  name: {{ printf "%ss-%s" $port.port_protocol $port.name }}
{{-       else }}
  name: {{ $port.name }}
{{-       end }}
{{-     else }}
- port: {{ default $port.port $port.plain_port }}
  targetPort: {{ $port.name }}
{{-       if $port.plain_port_l4_protocol }}
  protocol: {{ $port.plain_port_l4_protocol }}
{{-       else }}
  protocol: {{ default "TCP" $port.l4_protocol  }}
{{-       end }}
{{-       if $port.app_protocol }}
  appProtocol: {{ $port.app_protocol }}
{{-       end }}
{{-       if $port.port_protocol }}
  name: {{ printf "%s-%s" $port.port_protocol $port.name }}
{{-       else }}
  name: {{ $port.name }}
{{-       end }}
{{-     end }}
{{-     if (eq $serviceType "NodePort") }}
  nodePort: {{ include "common.nodePortPrefix" (dict "dot" $dot "useNodePortExt" $port.useNodePortExt) }}{{ $port.nodePort }}
{{-     end }}
{{-     if (and (and (include "common.needTLS" $dot) $add_plain_port) $port.plain_port)  }}
{{-       if (eq $serviceType "ClusterIP")  }}
- port: {{ $port.plain_port }}
  targetPort: {{ $port.name }}-plain
{{-         if $port.plain_l4_port_protocol }}
  protocol: {{ $port.plain_port_l4_protocol }}
{{-         else }}
  protocol: {{ default "TCP" $port.l4_protocol  }}
{{-         end }}
{{-       if $port.app_protocol }}
  appProtocol: {{ $port.app_protocol }}
{{-       end }}
{{-         if $port.port_protocol }}
  name: {{ printf "%s-%s" $port.port_protocol $port.name }}
{{-         else }}
  name: {{ $port.name }}-plain
{{-         end }}
{{-       end }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/* Create generic service template
     The function takes several arguments (inside a dictionary):
     - .dot : environment (.)
     - .ports : an array of ports
     - .serviceType: the type of the service
     - .suffix : a string which will be added at the end of the name (with a '-')
     - .annotations: the annotations to add
     - .msb_informations: msb information in order to create msb annotation
     - .publishNotReadyAddresses: if we publish not ready address
     - .headless: if the service is headless
     - .add_plain_port: add tls port AND plain port
     - .labels : labels to add (dict)
     - .matchLabels: selectors/machLabels to add (dict)
     - .sessionAffinity: ClientIP  - enables sticky sessions based on client IP, default: None
*/}}
{{- define "common.genericService" -}}
{{- $dot := default . .dot -}}
{{- $suffix := default "" .suffix -}}
{{- $annotations := default "" .annotations -}}
{{- $msb_informations := default "" .msb_informations -}}
{{- $publishNotReadyAddresses := default false .publishNotReadyAddresses -}}
{{- $serviceType := .serviceType -}}
{{- $ports := .ports -}}
{{- $headless := default false .headless -}}
{{- $add_plain_port := default false .add_plain_port }}
{{- $labels := default (dict) .labels -}}
{{- $matchLabels := default (dict) .matchLabels -}}
{{- $sessionAffinity := default "None" $dot.Values.service.sessionAffinity -}}
{{- $kubeTargetVersion := default $dot.Capabilities.KubeVersion.Version | trimPrefix "v" -}}
{{- $ipFamilyPolicy := default "PreferDualStack" $dot.Values.service.ipFamilyPolicy -}}
apiVersion: v1
kind: Service
metadata: {{ include "common.serviceMetadata" (dict "suffix" $suffix "annotations" $annotations "msb_informations" $msb_informations "labels" $labels "dot" $dot) | nindent 2 }}
spec:
  {{- if $headless }}
  clusterIP: None
  {{- end }}
  ports: {{- include "common.servicePorts" (dict "serviceType" $serviceType "ports" $ports "dot" $dot "add_plain_port" $add_plain_port) | nindent 4 }}
  {{- if semverCompare ">=1.20.0" $kubeTargetVersion }}
  ipFamilyPolicy: {{ $ipFamilyPolicy }}
  {{- end }}
  {{- if $publishNotReadyAddresses }}
  publishNotReadyAddresses: true
  {{- end }}
  type: {{ $serviceType }}
  selector: {{- include "common.matchLabels" (dict "matchLabels" $matchLabels "dot" $dot) | nindent 4 }}
  sessionAffinity: {{ $sessionAffinity }}
{{- end -}}

{{/*
    Create service template
    Will create one or two service templates according to this table:

    | serviceType   | both_tls_and_plain | result       |
    |---------------|--------------------|--------------|
    | ClusterIP     | any                | one Service  |
    | Not ClusterIP | not present        | one Service  |
    | Not ClusterIP | false              | one Service  |
    | Not ClusterIP | true               | two Services |

    If two services are created, one is ClusterIP with both crypted and plain
    ports and the other one is NodePort (or LoadBalancer) with crypted port only.
*/}}
{{- define "common.service" -}}
{{-   $dot := default . .dot -}}
{{-   $suffix := default "" $dot.Values.service.suffix -}}
{{-   $annotations := default "" $dot.Values.service.annotations -}}
{{-   $publishNotReadyAddresses := default false $dot.Values.service.publishNotReadyAddresses -}}
{{-   $msb_informations := default "" $dot.Values.service.msb -}}
{{-   $serviceType := $dot.Values.service.type -}}
{{-   $ports := $dot.Values.service.ports -}}
{{-   $both_tls_and_plain:= default false $dot.Values.service.both_tls_and_plain }}
{{-   $labels := default (dict) .labels -}}
{{-   $matchLabels := default (dict) .matchLabels -}}
{{-   if and (include "common.ingressEnabled" $dot) (eq $serviceType "NodePort") -}}
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

{{/* Create headless service template */}}
{{- define "common.headlessService" -}}
{{- $dot := default . .dot -}}
{{- $suffix := include "common._makeHeadlessSuffix" $dot -}}
{{- $annotations := default "" $dot.Values.service.headless.annotations -}}
{{- $publishNotReadyAddresses := default false $dot.Values.service.headless.publishNotReadyAddresses -}}
{{- $ports := $dot.Values.service.headlessPorts -}}
{{- $labels := default (dict) .labels -}}
{{- $matchLabels := default (dict) .matchLabels -}}
{{- if ($dot.Values.metrics) }}
{{-   range $index, $metricPort := $dot.Values.metrics.ports }}
{{-     $ports = append $ports $metricPort }}
{{-   end }}
{{- end }}
{{ include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" $dot "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" "ClusterIP" "headless" true "labels" $labels "matchLabels" $matchLabels) }}
{{- end -}}

{{/*
  Generate the right suffix for headless service
*/}}
{{- define "common._makeHeadlessSuffix" -}}
{{-   if hasKey .Values.service.headless "suffix" }}
{{-     .Values.service.headless.suffix }}
{{-   else }}
{{-     print "headless" }}
{{-   end }}
{{- end -}}

{{/*
  Calculate if we need to use TLS ports.
  We use TLS by default unless we're on service mesh with TLS.
  We can also override this behavior with override toggles:
  - .Values.global.tlsEnabled  : override default TLS behavior for all charts
  - .Values.tlsOverride : override global and default TLS on a per chart basis

  this will give these combinations:
  | tlsOverride | global.tlsEnabled | global.serviceMesh.enabled | global.serviceMesh.tls | result |
  |-------------|-------------------|----------------------------|------------------------|--------|
  | not present | not present       | not present                | any                    | true   |
  | not present | not present       | false                      | any                    | true   |
  | not present | not present       | true                       | false                  | true   |
  | not present | not present       | true                       | true                   | false  |
  | not present | true              | any                        | any                    | true   |
  | not present | false             | any                        | any                    | false  |
  | true        | any               | any                        | any                    | true   |
  | false       | any               | any                        | any                    | false  |

*/}}
{{- define "common.needTLS" -}}
{{-   if hasKey .Values "tlsOverride" }}
{{-     if .Values.tlsOverride -}}
true
{{-       end }}
{{-   else }}
{{-     if hasKey .Values.global "tlsEnabled" }}
{{-       if .Values.global.tlsEnabled }}
true
{{-       end }}
{{-     else }}
{{-       if not (include "common.onServiceMesh" .) -}}
true
{{-       else }}
{{-         if not (default false .Values.global.serviceMesh.tls) -}}
true
{{-         end }}
{{-       end }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/*
  generate needed scheme:
    - https if needTLS
    - http if not
*/}}

{{- define "common.scheme" -}}
  {{- ternary "https" "http" (eq "true" (include "common.needTLS" .)) }}
{{- end -}}

{{- define "common.port.buildCache" -}}
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
{{- define "common.getPort" -}}
  {{- $global := .global }}
  {{- $name := .name }}
  {{- $getPlain := default false .getPlain }}
  {{- include "common.port.buildCache" $global }}
  {{- $portCache := $global.Values._DmaapDrNodePortsCache }}
  {{- $port := index $portCache $name }}
  {{- ternary $port.plain_port $port.port $getPlain }}
{{- end -}}
