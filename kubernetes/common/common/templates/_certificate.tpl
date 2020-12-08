{{/*#
# Copyright © 2020, Nokia
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
# limitations under the License.*/}}

{{- define "common.certificate" -}}
{{- $dot := default . .dot -}}
{{- $certificates := $dot.Values.certificates -}}

{{-/*
# This is template for requesting a certificate from cert-manager (https://cert-manager.io).
#
# To request a certificate just create object certificates in values.yaml file in you component and invoke function "commom.certificate" in the file templates/certificates.yaml
# Here is an example of certificate definition (to be placed in values.yaml):

certificates:
  - name:       onap-sdnc-certificate
    secretName: onap-sdnc-certificate
    commonName: sdnc.simpledemo.onap.org
    dnsNames:
        - sdnc.simpledemo.onap.org

#  Fields 'name' and 'secretName' are mandatory and required to be defined.
#  Other mandatory field are taken from default values (see onap/values.yaml -> certificate.default) if not defined directly.
#
*/-}}

{{ range $certificate := $certificates }}
{{/*# General certifiacate attributes  #*/}}
{{- $name           := $certificate.name                                                                          -}}
{{- $secretName     := $certificate.secretName                                                                    -}}
{{- $namespace      := default $dot.Values.global.certificate.default.namespace       $certificate.namespace      -}}
{{- $commonName     := default $dot.Values.global.certificate.default.commonName      $certificate.commonName     -}}
{{- $renewBefore    := default $dot.Values.global.certificate.default.renewBefore     $certificate.renewBefore    -}}
{{- $duration       := $certificate.duration                                                                      -}}
{{/*# SAN's #*/}}
{{- $dnsNames       := default $dot.Values.global.certificate.default.dnsNames        $certificate.dnsNames       -}}
{{- $ipAddresses    := default $dot.Values.global.certificate.default.ipAddresses     $certificate.ipAddresses    -}}
{{- $uris           := default $dot.Values.global.certificate.default.uris            $certificate.uris           -}}
{{- $emailAddresses := default $dot.Values.global.certificate.default.emailAddresses  $certificate.emailAddresses -}}
{{/*# Subject #*/}}
{{- $organization   := $dot.Values.global.certificate.default.subject.organization        -}}
{{- $country        := $dot.Values.global.certificate.default.subject.country             -}}
{{- $locality       := $dot.Values.global.certificate.default.subject.locality            -}}
{{- $province       := $dot.Values.global.certificate.default.subject.province            -}}
{{- $orgUnit        := $dot.Values.global.certificate.default.subject.organizationalUnit  -}}
{{- if $certificate.subject -}}
{{- $organization   := default $dot.Values.global.certificate.default.subject.organization        $certificate.subject.organization -}}
{{- $country        := default $dot.Values.global.certificate.default.subject.country             $certificate.subject.country -}}
{{- $locality       := default $dot.Values.global.certificate.default.subject.locality            $certificate.subject.locality -}}
{{- $province       := default $dot.Values.global.certificate.default.subject.province            $certificate.subject.province -}}
{{- $orgUnit        := default $dot.Values.global.certificate.default.subject.organizationalUnit  $certificate.subject.organizationalUnit -}}
{{- end -}}
{{/*# Issuer #*/}}
{{- $issuerGroup    := $dot.Values.global.certificate.default.issuer.group  -}}
{{- $issuerKind     := $dot.Values.global.certificate.default.issuer.kind   -}}
{{- $issuerName     := $dot.Values.global.certificate.default.issuer.name   -}}
{{- if $certificate.issuer -}}
{{- $issuerGroup    := default $dot.Values.global.certificate.default.issuer.group    $certificate.issuer.group   -}}
{{- $issuerKind     := default $dot.Values.global.certificate.default.issuer.kind     $certificate.issuer.kind    -}}
{{- $issuerName     := default $dot.Values.global.certificate.default.issuer.name     $certificate.issuer.name    -}}
{{- end -}}
---
apiVersion: cert-manager.io/v1
kind: Certificate
metadata:
  name:        {{ $name }}
  namespace:   {{ $namespace }}
spec:
  secretName:  {{ $secretName }}
  commonName:  {{ $commonName }}
  renewBefore: {{ $renewBefore }}
  {{- if $duration }}
  duration:    {{ $duration }}
  {{- end }}
  subject:
    organizations:
      - {{ $organization }}
    countries:
      - {{ $country }}
    localities:
      - {{ $locality }}
    provinces:
      - {{ $province }}
    organizationalUnits:
      - {{ $orgUnit }}
  {{- if $dnsNames }}
  dnsNames:
    {{- range $dnsName := $dnsNames }}
      - {{$dnsName}}
    {{- end }}
  {{- end }}
  {{- if $ipAddresses }}
  ipAddresses:
    {{- range $ipAddress := $ipAddresses }}
      - {{$ipAddress}}
    {{- end }}
  {{- end }}
  {{- if $uris }}
  uris:
    {{- range $uri := $uris }}
      - {{$uri}}
    {{- end }}
  {{- end }}
  {{- if $emailAddresses }}
  emailAddresses:
    {{- range $emailAddress := $emailAddresses }}
      - {{$emailAddress}}
    {{- end }}
  {{- end }}
  issuerRef:
    group: {{ $issuerGroup }}
    kind:  {{ $issuerKind }}
    name:  {{ $issuerName }}
{{ end }}

{{- end -}}
