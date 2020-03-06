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

{{/* Define the metadata of Service
     The function takes from one to three arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : a string which will be added at the end of the name (with a '-').
     - .annotations: the annotations to add
     - .msb_informations: msb information in order to create msb annotation
     Usage example:
      {{ include "common.serviceMetadata" ( dict "suffix" "myService" "dot" .) }}
      {{ include "common.serviceMetadata" ( dict "annotations" .Values.service.annotation "dot" .) }}
*/}}
{{- define "common.serviceMetadata" -}}
  {{- $dot := default . .dot -}}
  {{- $suffix := default "" .suffix -}}
  {{- $annotations := default "" .annotations -}}
  {{- $msb_informations := default "" .msb_informations -}}
{{- if or $annotations $msb_informations -}}
annotations:
{{-   if $annotations }}
{{      include "common.tplValue" (dict "value" $annotations "context" $dot) | indent 2 }}
{{-   end }}
{{-   if $msb_informations }}
  msb.onap.org/service-info: '[
      {
          "serviceName": "{{ include "common.servicename" $dot }}",
          "version": "{{ default "v1" $msb_informations.version }}",
          "url": "{{ default "/" $msb_informations.url }}",
          "protocol": "{{ default "REST" $msb_informations.protocol }}",
          "port": "{{ $msb_informations.port }}",
          "visualRange":"{{ default "1" $msb_informations.visualRange }}"
      }
      ]'
{{-   end}}
{{- end }}
name: {{ include "common.servicename" $dot }}{{ if $suffix }}{{ print "-" $suffix }}{{ end }}
namespace: {{ include "common.namespace" $dot }}
labels: {{- include "common.labels" $dot | nindent 2 -}}
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
{{-       if $port.port_protocol }}
  name: {{ printf "%ss-%s" $port.port_protocol $port.name }}
{{-       else }}
  name: {{ $port.name }}
{{-       end }}
{{-       if (eq $serviceType "NodePort") }}
  nodePort: {{ $dot.Values.global.nodePortPrefix | default $dot.Values.nodePortPrefix }}{{ $port.nodePort }}
{{-       end }}
{{-     else }}
- port: {{ default $port.port $port.plain_port }}
  targetPort: {{ $port.name }}
{{-       if $port.port_protocol }}
  name: {{ printf "%s-%s" $port.port_protocol $port.name }}
{{-       else }}
  name: {{ $port.name }}
{{-       end }}
{{-     end }}
{{-     if (and (and (include "common.needTLS" $dot) $add_plain_port) $port.plain_port)  }}
{{-       if (eq $serviceType "ClusterIP")  }}
- port: {{ $port.plain_port }}
  targetPort: {{ $port.name }}-plain
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
apiVersion: v1
kind: Service
metadata: {{ include "common.serviceMetadata" (dict "suffix" $suffix "annotations" $annotations "msb_informations" $msb_informations "dot" $dot) | nindent 2 }}
spec:
  {{- if $headless }}
  clusterIP: None
  {{- end }}
  ports: {{- include "common.servicePorts" (dict "serviceType" $serviceType "ports" $ports "dot" $dot "add_plain_port" $add_plain_port) | nindent 4 }}
  {{- if $publishNotReadyAddresses }}
  publishNotReadyAddresses: true
  {{- end }}
  type: {{ $serviceType }}
  selector: {{- include "common.matchLabels" $dot | nindent 4 }}
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
{{-   $suffix := default "" .Values.service.suffix -}}
{{-   $annotations := default "" .Values.service.annotations -}}
{{-   $publishNotReadyAddresses := default false .Values.service.publishNotReadyAddresses -}}
{{-   $msb_informations := default "" .Values.service.msb -}}
{{-   $serviceType := .Values.service.type -}}
{{-   $ports := .Values.service.ports -}}
{{-   $both_tls_and_plain:= default false .Values.service.both_tls_and_plain }}
{{-   if (and (include "common.needTLS" .) $both_tls_and_plain) }}
{{      include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "msb_informations" $msb_informations "dot" . "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" "ClusterIP" "add_plain_port" true) }}
{{-     if (ne $serviceType "ClusterIP") }}
---
{{-       if $suffix }}
{{-         $suffix = printf "%s-external" $suffix }}
{{-       else }}
{{-         $suffix = "external" }}
{{-       end }}
{{        include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" . "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" $serviceType) }}
{{-     end }}
{{-   else }}
{{      include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" . "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" $serviceType) }}
{{-   end }}
{{- end -}}

{{/* Create headless service template */}}
{{- define "common.headlessService" -}}
{{- $suffix := include "common._makeHeadlessSuffix" . -}}
{{- $annotations := default "" .Values.service.headless.annotations -}}
{{- $publishNotReadyAddresses := default false .Values.service.headless.publishNotReadyAddresses -}}
{{- $ports := .Values.service.headlessPorts -}}
{{ include "common.genericService" (dict "suffix" $suffix "annotations" $annotations "dot" . "publishNotReadyAddresses" $publishNotReadyAddresses "ports" $ports "serviceType" "ClusterIP" "headless" true ) }}
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
