{{/*
# Copyright © 2019-2021 Orange, Samsung
# Copyright © 2022 Deutsche Telekom
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
  Helper function to check, if Ingress is globally enabled
*/}}
{{- define "common.ingressEnabled" -}}
{{-   $dot := default . .dot -}}
{{-   if $dot.Values.ingress -}}
{{-     if $dot.Values.global.ingress -}}
{{-       if (default false $dot.Values.global.ingress.enabled) -}}
true
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end -}}

{{/*
  Helper function to check, if Ingress is enabled
*/}}
{{- define "common.ingress._enabled" -}}
{{-   $dot := default . .dot -}}
{{-   if $dot.Values.ingress -}}
{{-     if $dot.Values.global.ingress -}}
{{-       if (default false $dot.Values.global.ingress.enabled) -}}
{{-         if (default false $dot.Values.global.ingress.enable_all) -}}
true
{{-         else -}}
{{-           if $dot.Values.ingress.enabled -}}
true
{{-           end -}}
{{-         end -}}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end -}}

{{/*
  Helper function to check, if TLS redirect is enabled
*/}}
{{- define "common.ingress._tlsRedirect" -}}
{{-   $dot := default . .dot -}}
{{-   if $dot.Values.global.ingress.config }}
{{-     if $dot.Values.global.ingress.config.ssl }}
{{-       if eq $dot.Values.global.ingress.config.ssl "redirect" }}
true
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{- end -}}

{{/*
  Helper function to get the Ingress Provider (default is "ingress")
*/}}
{{- define "common.ingress._provider" -}}
{{-   $dot := default . .dot -}}
{{-   $provider := "ingress" -}}
{{-   if $dot.Values.global.ingress -}}
{{-     if $dot.Values.global.ingress.provider -}}
{{-       if ne $dot.Values.global.ingress.provider "" -}}
{{          $provider = $dot.Values.global.ingress.provider }}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{-   $provider -}}
{{- end -}}

{{/*
  Helper function to get the Ingress Class (default is "nginx")
*/}}
{{- define "common.ingress._class" -}}
{{-   $dot := default . .dot -}}
{{-   $class := "nginx" -}}
{{-   if $dot.Values.global.ingress -}}
{{-     if $dot.Values.global.ingress.ingressClass -}}
{{-       if ne $dot.Values.global.ingress.ingressClass "" -}}
{{          $class = $dot.Values.global.ingress.ingressClass }}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{-   $class -}}
{{- end -}}

{{/*
  Helper function to get the Ingress Selector (default is "ingress")
*/}}
{{- define "common.ingress._selector" -}}
{{-   $dot := default . .dot -}}
{{-   $selector := "ingress" -}}
{{-   if $dot.Values.global.ingress -}}
{{-     if $dot.Values.global.ingress.ingressSelector -}}
{{-       if ne $dot.Values.global.ingress.ingressSelector "" -}}
{{          $selector = $dot.Values.global.ingress.ingressSelector }}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{-   $selector -}}
{{- end -}}

{{/*
  Helper function to get the common Gateway, if exists
*/}}
{{- define "common.ingress._commonGateway" -}}
{{-   $dot := default . .dot -}}
{{-   $gateway := "-" -}}
{{-   if $dot.Values.global.ingress -}}
{{-     if $dot.Values.global.ingress.commonGateway -}}
{{-       if $dot.Values.global.ingress.commonGateway.name -}}
{{          $gateway = $dot.Values.global.ingress.commonGateway.name }}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{-   $gateway -}}
{{- end -}}

{{/*
  Helper function to get the common Gateway HTTP Listener name, if exists
*/}}
{{- define "common.ingress._gatewayHTTPListener" -}}
{{-   $dot := default . .dot -}}
{{-   $listener := "http-80" -}}
{{-   if $dot.Values.global.ingress -}}
{{-     if $dot.Values.global.ingress.commonGateway -}}
{{-       if $dot.Values.global.ingress.commonGateway.name -}}
{{          $listener = $dot.Values.global.ingress.commonGateway.httpListener }}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{-   $listener -}}
{{- end -}}

{{/*
  Helper function to get the common Gateway HTTPS Listener name, if exists
*/}}
{{- define "common.ingress._gatewayHTTPSListener" -}}
{{-   $dot := default . .dot -}}
{{-   $listener := "https-443" -}}
{{-   if $dot.Values.global.ingress -}}
{{-     if $dot.Values.global.ingress.commonGateway -}}
{{-       if $dot.Values.global.ingress.commonGateway.name -}}
{{          $listener = $dot.Values.global.ingress.commonGateway.httpsListener }}
{{-       end -}}
{{-     end -}}
{{-   end -}}
{{-   $listener -}}
{{- end -}}

{{/*
  Helper function to check the existance of an override value
*/}}
{{- define "common.ingress._overrideIfDefined" -}}
  {{- $currValue := .currVal }}
  {{- $parent := .parent }}
  {{- $var := .var }}
  {{- if $parent -}}
    {{- if hasKey $parent $var }}
      {{- default "" (index $parent $var) }}
    {{- else -}}
      {{- default "" $currValue -}}
    {{- end -}}
  {{- else -}}
    {{- default "" $currValue }}
  {{- end -}}
{{- end -}}

{{/*
  Helper function to get the protocol of the service
*/}}
{{- define "common.ingress._protocol" -}}
{{-   $dot := default . .dot -}}
{{-   $protocol := "http" -}}
{{-   if $dot.tcpRoutes }}
{{-     $protocol = "tcp" -}}
{{-   end -}}
{{-   if $dot.udpRoutes }}
{{-     $protocol = "tcp" -}}
{{-   end -}}
{{-   if $dot.protocol }}
{{-     $protocol = (lower $dot.protocol) -}}
{{-   end -}}
{{-   $protocol -}}
{{- end -}}

{{/*
  Create the hostname as concatination <baseaddr>.<baseurl>
  - baseaddr: from component values: ingress.service.baseaddr
  - baseurl: from values: global.ingress.virtualhost.baseurl
    which van be overwritten in the component via: ingress.baseurlOverride
*/}}
{{- define "ingress.config.host" -}}
{{-   $dot := default . .dot -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $preaddr := default "" $dot.Values.global.ingress.virtualhost.preaddr -}}
{{-   $preaddr := include "common.ingress._overrideIfDefined" (dict "currVal" $preaddr "parent" (default (dict) $dot.Values.ingress) "var" "preaddrOverride") -}}
{{-   $postaddr := default "" $dot.Values.global.ingress.virtualhost.postaddr -}}
{{-   $postaddr := include "common.ingress._overrideIfDefined" (dict "currVal" $postaddr "parent" (default (dict) $dot.Values.ingress) "var" "postaddrOverride") -}}
{{-   $burl := (required "'baseurl' param, set to the generic part of the fqdn, is required." $dot.Values.global.ingress.virtualhost.baseurl) -}}
{{-   $burl := include "common.ingress._overrideIfDefined" (dict "currVal" $burl "parent" (default (dict) $dot.Values.ingress) "var" "baseurlOverride") -}}
{{ printf "%s%s%s.%s" $preaddr $baseaddr $postaddr $burl }}
{{- end -}}

{{/*
  Istio Helper function to add the tls route
*/}}
{{- define "istio.config.tls_simple" -}}
{{-   $dot := default . .dot -}}
    tls:
{{-   if $dot.Values.global.ingress.config }}
{{-     if $dot.Values.global.ingress.config.tls }}
      credentialName: {{ default "ingress-tls-secret" $dot.Values.global.ingress.config.tls.secret }}
{{-     else }}
      credentialName: "ingress-tls-secret"
{{-     end }}
{{-   else }}
      credentialName: "ingress-tls-secret"
{{-   end }}
      mode: SIMPLE
{{- end -}}

{{/*
  Istio Helper function to add the tls route
*/}}
{{- define "istio.config.tls" -}}
{{-   $dot := default . .dot -}}
{{-   $service := (required "'service' param, set to the specific service, is required." .service) -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   if $service.exposedPort }}
{{-     if $service.exposedProtocol }}
{{-       if eq $service.exposedProtocol "TLS" }}
    {{ include "istio.config.tls_simple" (dict "dot" $dot ) }}
{{-       end }}
{{-     end }}
{{-   else }}
{{-     if $dot.Values.global.ingress.config }}
{{-       if $dot.Values.global.ingress.config.ssl }}
{{-         if eq $dot.Values.global.ingress.config.ssl "redirect" }}
    tls:
      httpsRedirect: true
  - port:
      number: 443
      name: https
      protocol: HTTPS
    {{ include "istio.config.tls_simple" (dict "dot" $dot ) }}
    hosts:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
{{-         end }}
{{-       end }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/*
  Istio Helper function to add the external port of the service
*/}}
{{- define "istio.config.port" -}}
{{-   $dot := default . .dot -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $protocol := (required "'protocol' param, set to the name of the port, is required." .protocol) -}}
{{-   if $dot.exposedPort }}
      number: {{ $dot.exposedPort }}
{{-     if $dot.exposedProtocol }}
      name: {{ $protocol }}-{{ $dot.exposedPort }}
      protocol: {{ $dot.exposedProtocol }}
{{-     else }}
      name: {{ $protocol }}
      protocol: HTTP
{{-     end -}}
{{-   else }}
      number: 80
      name: {{ $protocol }}
      protocol: HTTP
{{-   end -}}
{{- end -}}

{{/*
  Create Port entry in the Gateway resource
*/}}
{{- define "istio.config.gatewayPort" -}}
{{-   $dot := default . .dot -}}
{{-   $service := (required "'service' param, set to the specific service, is required." .service) -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $protocol := (required "'protocol' param, set to the specific port, is required." .protocol) -}}
  - port:
      {{- include "istio.config.port" (dict "dot" $service "baseaddr" $baseaddr "protocol" $protocol) }}
    hosts:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    {{- include "istio.config.tls" (dict "dot" $dot "service" $service "baseaddr" $baseaddr) }}
{{- end -}}

{{/*
  Helper function to add the route to the service
*/}}
{{- define "ingress.config.port" -}}
{{-   $dot := default . .dot -}}
{{ range .Values.ingress.service }}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) }}
  - host: {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    http:
      paths:
      - backend:
          service:
            name: {{ .name }}
            port:
            {{- if kindIs "string" .port }}
              name: {{ .port }}
            {{- else }}
              number: {{ .port }}
            {{- end }}
        {{- if .path }}
        path: {{ .path }}
        {{- end }}
        pathType: ImplementationSpecific
{{- end }}
{{- end -}}

{{/*
  Istio Helper function to add the route to the service
*/}}
{{- define "istio.config.route" -}}
{{- $dot := default . .dot -}}
{{- $protocol := (required "'protocol' param, is required." .protocol) -}}
{{- if eq $protocol "tcp" }}
  - match:
    - port: {{ $dot.exposedPort }}
    route:
    - destination:
        port:
        {{- if $dot.plain_port }}
        {{- if kindIs "string" $dot.plain_port }}
          name: {{ $dot.plain_port }}
        {{- else }}
          number: {{ $dot.plain_port }}
        {{- end }}
        {{- else }}
        {{- if kindIs "string" $dot.port }}
          name: {{ $dot.port }}
        {{- else }}
          number: {{ $dot.port }}
        {{- end }}
        {{- end }}
        host: {{ $dot.name }}
{{- else if eq $protocol "http" }}
  - route:
    - destination:
        port:
        {{- if $dot.plain_port }}
        {{- if kindIs "string" $dot.plain_port }}
          name: {{ $dot.plain_port }}
        {{- else }}
          number: {{ $dot.plain_port }}
        {{- end }}
        {{- else }}
        {{- if kindIs "string" $dot.port }}
          name: {{ $dot.port }}
        {{- else }}
          number: {{ $dot.port }}
        {{- end }}
        {{- end }}
        host: {{ $dot.name }}
{{- end -}}
{{- end -}}

{{/*
  Helper function to add ssl annotations
*/}}
{{- define "ingress.config.annotations.ssl" -}}
{{- $class := include "common.ingress._class" (dict "dot" .) }}
{{- if .Values.ingress.config -}}
{{- if .Values.ingress.config.ssl -}}
{{- if eq .Values.ingress.config.ssl "redirect" -}}
kubernetes.io/ingress.class: {{ $class }}
{{ $class }}.ingress.kubernetes.io/ssl-passthrough: "true"
{{ $class }}.ingress.kubernetes.io/ssl-redirect: "true"
{{-  else if eq .Values.ingress.config.ssl "native" -}}
{{ $class }}.ingress.kubernetes.io/ssl-redirect: "true"
{{-  else if eq .Values.ingress.config.ssl "none" -}}
{{ $class }}.ingress.kubernetes.io/ssl-redirect: "false"
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{/*
  Helper function to add annotations
*/}}
{{- define "ingress.config.annotations" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.annotations -}}
{{ toYaml .Values.ingress.annotations | indent 4 | trim }}
{{- end -}}
{{- end -}}
{{ include "ingress.config.annotations.ssl" . | indent 4 | trim }}
{{- end -}}

{{/*
  Create Istio Ingress resources per defined service
*/}}
{{- define "common.istioIngress" -}}
{{- $dot := default . .dot -}}
{{- $selector := include "common.ingress._selector" (dict "dot" $dot) }}
{{- $gateway := include "common.ingress._commonGateway" (dict "dot" $dot) }}
{{  range $dot.Values.ingress.service }}
{{    if or ( eq (include "common.ingress._protocol" (dict "dot" .)) "http" ) ( eq (include "common.ingress._protocol" (dict "dot" .)) "tcp" )}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) }}
{{-     if eq $gateway "-" }}
---
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: {{ $baseaddr }}-gateway
spec:
  selector:
    istio: {{ $selector }}
  servers:
{{-       if .tcpRoutes }}
{{          range .tcpRoutes }}
  {{ include "istio.config.gatewayPort" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "tcp") | trim }}
{{          end -}}
{{-       else }}
  {{-       if .protocol }}
  {{ include "istio.config.gatewayPort" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" .protocol) | trim }}
  {{-       else }}
  {{ include "istio.config.gatewayPort" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "http") | trim }}
  {{        end }}
{{        end }}
{{      end }}
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ $baseaddr }}-service
spec:
  hosts:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  gateways:
{{-   if eq $gateway "-" }}
  - {{ $baseaddr }}-gateway
{{-   else }}
  - {{ $gateway }}
{{-   end }}
{{-   if .tcpRoutes }}
  tcp:
{{      range .tcpRoutes }}
  {{ include "istio.config.route" (dict "dot" . "protocol" "tcp") | trim }}
{{      end -}}
{{-   else  }}
  {{-   if .protocol }}
  {{ .protocol }}:
  {{ include "istio.config.route" (dict "dot" . "protocol" .protocol) | trim }}
  {{-   else }}
  http:
  {{ include "istio.config.route" (dict "dot" . "protocol" "http") | trim }}
  {{-   end }}
{{-   end }}
{{- end }}
{{- end }}
{{- end -}}

{{/*
  GW-API Helper function to add the tls route
*/}}
{{- define "gwapi.config.tls_simple" -}}
{{-   $dot := default . .dot -}}
    tls:
{{-   if $dot.Values.global.ingress.config }}
{{-     if $dot.Values.global.ingress.config.tls }}
      certificateRefs:
        - kind: Secret
          group: ""
          name: {{ default "ingress-tls-secret" $dot.Values.global.ingress.config.tls.secret }}
{{-     else }}
      certificateRefs:
        - kind: Secret
          group: ""
          name: "ingress-tls-secret"
{{-     end }}
{{-   else }}
      certificateRefs:
        - kind: Secret
          group: ""
          name: "ingress-tls-secret"
{{-   end }}
      mode: Terminate
{{- end -}}

{{/*
  GW-API Helper function to add the tls route
*/}}
{{- define "gwapi.config.tls" -}}
{{-   $dot := default . .dot -}}
{{-   $service := (required "'service' param, set to the specific service, is required." .service) -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   if $service.exposedPort }}
{{-     if $service.exposedProtocol }}
{{-       if eq $service.exposedProtocol "TLS" }}
    {{ include "gwapi.config.tls_simple" (dict "dot" $dot ) }}
{{-       end }}
{{-     end }}
{{-   else }}
{{-     if (include "common.ingress._tlsRedirect" (dict "dot" $dot)) }}
  - name: HTTPS-443
    port: 443
    protocol: HTTPS
    hostname: {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    {{ include "gwapi.config.tls_simple" (dict "dot" $dot ) }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/*
  Create Listener entry in the Gateway resource
*/}}
{{- define "gwapi.config.listener" -}}
{{-   $dot := default . .dot -}}
{{-   $service := (required "'service' param, set to the specific service, is required." .service) -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $protocol := (required "'protocol' param, set to the specific port, is required." .protocol) -}}
{{-   $port := default 80 $service.exposedPort -}}
  - name: {{ $protocol }}-{{ $port }}
    port: {{ $port }}
{{-   if $service.exposedProtocol }}
    protocol: {{ upper $service.exposedProtocol }}
{{-   else }}
    protocol: HTTP
{{-   end }}
    hostname: {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    allowedRoutes:
      namespaces:
        from: All
{{-   if eq $service.protocol "tcp" }}
        kinds:
          - kind: TCPRoute
{{-   else if eq $service.protocol "tcp" }}
        kinds:
          - kind: UDPRoute
{{-   end }}
    {{- include "gwapi.config.tls" (dict "dot" $dot "service" $service "baseaddr" $baseaddr) }}
{{- end -}}

{{/*
  Create *Route entry for the Gateway-API
*/}}
{{- define "gwapi.config.route" -}}
{{-   $dot := default . .dot -}}
{{-   $service := (required "'service' param, set to the specific service, is required." .service) -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $protocol := (required "'protocol' param, set to the specific port, is required." .protocol) -}}
{{-   $gateway := include "common.ingress._commonGateway" (dict "dot" $dot) -}}
{{-   $namespace := default "istio-ingress" $dot.Values.global.ingress.namespace -}}
{{-   $path := default "/" $service.path -}}
{{-   if eq $protocol "udp" -}}
---
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: UDPRoute
metadata:
  name: {{ $baseaddr }}-{{ $service.exposedPort }}-route
spec:
  parentRefs:
{{-     if eq $gateway "-" }}
    - name: {{ $baseaddr }}-gateway
{{-     else }}
    - name: {{ $gateway }}
{{-     end }}
      namespace: {{ $namespace }}
      sectionName: udp-{{ $service.exposedPort }}
  rules:
    - backendRefs:
      - name: {{ $service.name }}
        port: {{ $service.port }}
{{-   else if eq $protocol "tcp" }}
---
apiVersion: gateway.networking.k8s.io/v1alpha2
kind: TCPRoute
metadata:
  name: {{ $baseaddr }}-{{ $service.exposedPort }}-route
spec:
  parentRefs:
{{-     if eq $gateway "-" }}
    - name: {{ $baseaddr }}-gateway
{{-     else }}
    - name: {{ $gateway }}
{{-     end }}
      namespace: {{ $namespace }}
      sectionName: tcp-{{ $service.exposedPort }}
  rules:
    - backendRefs:
      - name: {{ $service.name }}
        port: {{ $service.port }}
{{-   else if eq $protocol "http" }}
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: {{ $baseaddr }}-http-route
spec:
  parentRefs:
{{-     if eq $gateway "-" }}
    - name: {{ $baseaddr }}-gateway
{{-     else }}
    - name: {{ $gateway }}
{{-     end }}
      namespace: {{ $namespace }}
{{-     if (include "common.ingress._tlsRedirect" (dict "dot" $dot)) }}
      sectionName: {{ include "common.ingress._gatewayHTTPSListener" (dict "dot" $dot) }}
{{-     else }}
      sectionName: {{ include "common.ingress._gatewayHTTPListener" (dict "dot" $dot) }}
{{-     end }}
  hostnames:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  rules:
    - backendRefs:
      - name: {{ $service.name }}
        port: {{ $service.port }}
      matches:
        - path:
            type: PathPrefix
            value: {{ $path }}
{{-     if (include "common.ingress._tlsRedirect" (dict "dot" $dot)) }}
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: HTTPRoute
metadata:
  name: {{ $baseaddr }}-redirect-route
spec:
  parentRefs:
{{-       if eq $gateway "-" }}
    - name: {{ $baseaddr }}-gateway
{{-       else }}
    - name: {{ $gateway }}
{{-       end }}
      namespace: {{ $namespace }}
      sectionName: {{ include "common.ingress._gatewayHTTPListener" (dict "dot" $dot) }}
  hostnames:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  rules:
    - filters:
      - type: RequestRedirect
        requestRedirect:
          scheme: https
          statusCode: 301
          port: 443
      matches:
        - path:
            type: PathPrefix
            value: {{ $path }}
{{-     end }}
{{-   end }}
{{- end -}}

{{/*
  Create GW-API Ingress resources per defined service
*/}}
{{- define "common.gwapiIngress" -}}
{{- $dot := default . .dot -}}
{{- $selector := include "common.ingress._selector" (dict "dot" $dot) }}
{{- $gateway := include "common.ingress._commonGateway" (dict "dot" $dot) }}
{{  range $dot.Values.ingress.service }}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) }}
{{-   if eq $gateway "-" }}
---
apiVersion: gateway.networking.k8s.io/v1beta1
kind: Gateway
metadata:
  name: {{ $baseaddr }}-gateway
spec:
  gatewayClassName: {{ $dot.Values.global.serviceMesh.engine }}
  listeners:
{{-     if .tcpRoutes }}
{{        range .tcpRoutes }}
  {{ include "gwapi.config.listener" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "tcp") | trim }}
{{-        end -}}
{{-     else if .udpRoutes }}
{{        range .udpRoutes }}
  {{ include "gwapi.config.listener" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "udp") | trim }}
{{-       end -}}
{{-     else }}
{{-       if .protocol }}
  {{ include "gwapi.config.listener" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" (lower .protocol)) | trim }}
{{-       else }}
  {{ include "gwapi.config.listener" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "http") | trim }}
{{-       end }}
{{-     end }}
{{-   end }}
{{-   if .tcpRoutes }}
{{      range .tcpRoutes }}
{{ include "gwapi.config.route" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "tcp") | trim }}
{{-     end -}}
{{-   else if .udpRoutes }}
{{      range .udpRoutes }}
{{ include "gwapi.config.route" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "udp") | trim }}
{{-     end -}}
{{-   else }}
{{-     if .protocol }}
{{ include "gwapi.config.route" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" (lower .protocol)) | trim }}
{{-     else }}
{{ include "gwapi.config.route" (dict "dot" $dot "service" . "baseaddr" $baseaddr "protocol" "http") | trim }}
{{-     end }}
{{-   end }}
{{- end }}
{{- end -}}

{{/*
  Create default Ingress resource
*/}}
{{- define "common.nginxIngress" -}}
{{- $dot := default . .dot -}}
{{  range $dot.Values.ingress.service }}
{{    if eq (include "common.ingress._protocol" (dict "dot" .)) "http" }}
{{      $baseaddr := required "baseaddr" .baseaddr }}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.fullname" $dot }}-ingress
  annotations:
    {{ include "ingress.config.annotations" $dot }}
  labels:
    app: {{ $dot.Chart.Name }}
    chart: {{ $dot.Chart.Name }}-{{ $dot.Chart.Version | replace "+" "_" }}
    release: {{ include "common.release" $dot }}
    heritage: {{ $dot.Release.Service }}
spec:
  rules:
  {{ include "ingress.config.port" . | trim }}
{{-     if $dot.Values.ingress.tls }}
  tls:
{{ toYaml $dot.Values.ingress.tls | indent 4 }}
{{-     end -}}
{{-     if $dot.Values.ingress.config -}}
{{-       if $dot.Values.ingress.config.tls }}
  tls:
  - hosts:
    - {{ include "ingress.config.host" (dict "dot" . "baseaddr" $baseaddr) }}
    secretName: {{ required "secret" (tpl (default "" $dot.Values.ingress.config.tls.secret) $dot) }}
{{-       end }}
{{-     end }}
{{-   end }}
{{- end }}
{{- end -}}

{{/*
  Create ingress template
    Will create ingress template depending on the following values:
    - .Values.global.ingress.enabled     : enables Ingress globally
    - .Values.global.ingress.enable_all  : override default Ingress for all charts
    - .Values.ingress.enabled            : sets Ingress per chart basis

    | global.ingress.enabled | global.ingress.enable_all |ingress.enabled | result     |
    |------------------------|---------------------------|----------------|------------|
    | false                  | any                       | any            | no ingress |
    | true                   | false                     | false          | no ingress |
    | true                   | true                      | any            | ingress    |
    | true                   | false                     | true           | ingress    |

    If ServiceMesh (Ingress-Provider: Istio) is enabled the respective resources 
    are created:
    - Gateway (optional)
    - VirtualService

    If ServiceMesh (Ingress-Provider: GatewayAPI) is enabled the respective resources 
    are created:
    - Gateway (optional)
    - HTTPRoute, TCPRoute, UDPRoute (depending)

    If ServiceMesh is disabled the standard Ingress resource is creates:
    - Ingress
*/}}
{{- define "common.ingress" -}}
{{-   $dot := default . .dot -}}
{{-   $provider := include "common.ingress._provider" (dict "dot" $dot) -}}
{{-   if (include "common.ingress._enabled" (dict "dot" $dot)) }}
{{-     if eq $provider "ingress" -}}
{{        include "common.nginxIngress" (dict "dot" $dot) }}
{{-     else if eq $provider "istio" -}}
{{        include "common.istioIngress" (dict "dot" $dot) }}
{{-     else if eq $provider "gw-api" -}}
{{        include "common.gwapiIngress" (dict "dot" $dot) }}
{{-     end -}}
{{-   end -}}
{{- end -}}
