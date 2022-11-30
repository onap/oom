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
  Create the hostname as concatination <baseaddr>.<baseurl>
  - baseaddr: from component values: ingress.service.baseaddr
  - baseurl: from values: global.ingress.virtualhost.baseurl
    which van be overwritten in the component via: ingress.baseurlOverride
*/}}
{{- define "ingress.config.host" -}}
{{-   $dot := default . .dot -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $burl := (required "'baseurl' param, set to the generic part of the fqdn, is required." $dot.Values.global.ingress.virtualhost.baseurl) -}}
{{-   $burl := include "common.ingress._overrideIfDefined" (dict "currVal" $burl "parent" (default (dict) $dot.Values.ingress) "var" "baseurlOverride") -}}
{{ printf "%s.%s" $baseaddr $burl }}
{{- end -}}

{{/*
  Helper function to add the tls route
*/}}
{{- define "ingress.config.tls" -}}
{{-   $dot := default . .dot -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   if $dot.Values.global.ingress.config }}
{{-     if $dot.Values.global.ingress.config.ssl }}
{{-       if eq $dot.Values.global.ingress.config.ssl "redirect" }}
    tls:
      httpsRedirect: true
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
{{-         if $dot.Values.global.ingress.config }}
{{-           if $dot.Values.global.ingress.config.tls }}
      credentialName: {{ default "ingress-tls-secret" $dot.Values.global.ingress.config.tls.secret }}
{{-           else }}
      credentialName: "ingress-tls-secret"
{{-           end }}
{{-         else }}
      credentialName: "ingress-tls-secret"
{{-         end }}
      mode: SIMPLE
    hosts:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
{{-       end }}
{{-     end }}
{{-   end }}
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
  Helper function to add the route to the service
*/}}
{{- define "istio.config.route" -}}
{{-   $dot := default . .dot -}}
  http:
  - route:
    - destination:
        port:
        {{- if .plain_port }}
        {{- if kindIs "string" .plain_port }}
          name: {{ .plain_port }}
        {{- else }}
          number: {{ .plain_port }}
        {{- end }}
        {{- else }}
        {{- if kindIs "string" .port }}
          name: {{ .port }}
        {{- else }}
          number: {{ .port }}
        {{- end }}
        {{- end }}
        host: {{ .name }}
{{- end -}}

{{/*
  Helper function to add ssl annotations
*/}}
{{- define "ingress.config.annotations.ssl" -}}
{{- if .Values.ingress.config -}}
{{- if .Values.ingress.config.ssl -}}
{{- if eq .Values.ingress.config.ssl "redirect" -}}
kubernetes.io/ingress.class: nginx
nginx.ingress.kubernetes.io/ssl-passthrough: "true"
nginx.ingress.kubernetes.io/ssl-redirect: "true"
{{-  else if eq .Values.ingress.config.ssl "native" -}}
nginx.ingress.kubernetes.io/ssl-redirect: "true"
{{-  else if eq .Values.ingress.config.ssl "none" -}}
nginx.ingress.kubernetes.io/ssl-redirect: "false"
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
  Create Istio Ingress resources per defined service
*/}}
{{- define "common.istioIngress" -}}
{{-   $dot := default . .dot -}}
{{    range $dot.Values.ingress.service }}
{{-     $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) }}
---
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: {{ $baseaddr }}-gateway
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    {{ include "ingress.config.tls" (dict "dot" $dot "baseaddr" $baseaddr) }}
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ $baseaddr }}-service
spec:
  hosts:
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  gateways:
  - {{ $baseaddr }}-gateway
  {{ include "istio.config.route" . | trim }}
{{-   end -}}
{{- end -}}

{{/*
  Create default Ingress resource
*/}}
{{- define "common.nginxIngress" -}}
{{- $dot := default . .dot -}}
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
  {{ include "ingress.config.port" $dot | trim }}
{{- if $dot.Values.ingress.tls }}
  tls:
{{ toYaml $dot.Values.ingress.tls | indent 4 }}
{{- end -}}
{{- if $dot.Values.ingress.config -}}
{{-   if $dot.Values.ingress.config.tls -}}
  tls:
  - hosts:
  {{-   range $dot.Values.ingress.service }}{{ $baseaddr := required "baseaddr" .baseaddr }}
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  {{-   end }}
    secretName: {{ required "secret" (tpl (default "" $dot.Values.ingress.config.tls.secret) $dot) }}
{{-   end -}}
{{- end -}}
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

    If ServiceMesh (Istio) is enabled the respective resources are created:
    - Gateway
    - VirtualService

    If ServiceMesh is disabled the standard Ingress resource is creates:
    - Ingress
*/}}
{{- define "common.ingress" -}}
{{-   $dot := default . .dot -}}
{{-   if (include "common.ingress._enabled" (dict "dot" $dot)) }}
{{-     if (include "common.onServiceMesh" .) }}
{{-       if eq (default "istio" .Values.global.serviceMesh.engine) "istio" }}
{{          include "common.istioIngress" (dict "dot" $dot) }}
{{-       end -}}
{{-     else -}}
{{        include "common.nginxIngress" (dict "dot" $dot) }}
{{-     end -}}
{{-   end -}}
{{- end -}}
