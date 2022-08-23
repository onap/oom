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
{{- define "ingress.config.host" -}}
{{-   $dot := default . .dot -}}
{{-   $baseaddr := (required "'baseaddr' param, set to the specific part of the fqdn, is required." .baseaddr) -}}
{{-   $burl := (required "'baseurl' param, set to the generic part of the fqdn, is required." $dot.Values.global.ingress.virtualhost.baseurl) -}}
{{ printf "%s.%s" $baseaddr $burl }}
{{- end -}}

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

{{- define "istio.config.route" -}}
{{-   $dot := default . .dot -}}
{{ range .Values.ingress.service }}
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
{{- end -}}

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


{{- define "ingress.config.annotations" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.annotations -}}
{{ toYaml .Values.ingress.annotations | indent 4 | trim }}
{{- end -}}
{{- end -}}
{{ include "ingress.config.annotations.ssl" . | indent 4 | trim }}
{{- end -}}

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

{{- define "common.ingress" -}}
{{-   $dot := default . .dot -}}
{{- if .Values.ingress -}}
  {{- $ingressEnabled := default false .Values.ingress.enabled -}}
  {{- $ingressEnabled := include "common.ingress._overrideIfDefined" (dict "currVal" $ingressEnabled "parent" (default (dict) .Values.global.ingress) "var" "enabled") }}
  {{- $ingressEnabled := include "common.ingress._overrideIfDefined" (dict "currVal" $ingressEnabled "parent" .Values.ingress "var" "enabledOverride") }}
{{- if $ingressEnabled }}
{{- if (include "common.onServiceMesh" .) }}
{{- if eq (default "istio" .Values.global.serviceMesh.engine) "istio" }}
      {{-   $dot := default . .dot -}}
apiVersion: networking.istio.io/v1beta1
kind: Gateway
metadata:
  name: {{ include "common.fullname" . }}-gateway
spec:
  selector:
    istio: ingressgateway # use Istio default gateway implementation
  servers:
  - port:
      number: 80
      name: http
      protocol: HTTP
    hosts:
    {{- range .Values.ingress.service }}{{ $baseaddr := required "baseaddr" .baseaddr }}
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    {{- end }}
{{- if .Values.global.ingress.config }}
{{- if .Values.global.ingress.config.ssl }}
{{- if eq .Values.global.ingress.config.ssl "redirect" }}
    tls:
      httpsRedirect: true
  - port:
      number: 443
      name: https
      protocol: HTTPS
    tls:
{{- if .Values.global.ingress.config }}
{{- if .Values.global.ingress.config.tls }}
      credentialName: {{ default "ingress-tls-secret" .Values.global.ingress.config.tls.secret }}
{{- else }}
      credentialName: "ingress-tls-secret"
{{- end }}
{{- else }}
      credentialName: "ingress-tls-secret"
{{- end }}
      mode: SIMPLE
    hosts:
    {{- range .Values.ingress.service }}{{ $baseaddr := required "baseaddr" .baseaddr }}
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
    {{- end }}
{{- end }}
{{- end }}
{{- end }}
---
apiVersion: networking.istio.io/v1beta1
kind: VirtualService
metadata:
  name: {{ include "common.fullname" . }}-service
spec:
  hosts:
  {{- range .Values.ingress.service }}{{ $baseaddr := required "baseaddr" .baseaddr }}
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  {{- end }}
  gateways:
  - {{ include "common.fullname" . }}-gateway
  {{ include "istio.config.route" . | trim }}
{{- end -}}
{{- else -}}
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: {{ include "common.fullname" . }}-ingress
  annotations:
    {{ include "ingress.config.annotations" . }}
  labels:
    app: {{ .Chart.Name }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ include "common.release" . }}
    heritage: {{ .Release.Service }}
spec:
  rules:
  {{ include "ingress.config.port" . | trim }}
{{- if .Values.ingress.tls }}
  tls:
{{ toYaml .Values.ingress.tls | indent 4 }}
{{- end -}}
{{- if .Values.ingress.config -}}
{{- if .Values.ingress.config.tls -}}
  tls:
  - hosts:
  {{- range .Values.ingress.service }}{{ $baseaddr := required "baseaddr" .baseaddr }}
    - {{ include "ingress.config.host" (dict "dot" $dot "baseaddr" $baseaddr) }}
  {{- end }}
    secretName: {{ required "secret" (tpl (default "" .Values.ingress.config.tls.secret) $dot) }}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
