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

{{/*
# This is a template for requesting a certificate from the cert-manager (https://cert-manager.io).
#
# To request a certificate following steps are to be done:
#  - create an object 'certificates' in the values.yaml
#  - create a file templates/certificates.yaml and invoke the function "commom.certificate".
#
# Here is an example of the certificate request for a component:
#
# Directory structure:
#   component
#     templates
#       certifictes.yaml
#     values.yaml
#
# To be added in the file certificates.yamll
#
# To be added in the file values.yaml
#  certificates:
#    - name:       onap-component-certificate
#      secretName: onap-component-certificate
#      commonName: component.onap.org
#      dnsNames:
#        - component.onap.org
#
# Fields 'name', 'secretName' and 'commonName' are mandatory and required to be defined.
# Other mandatory fields for the certificate definition do not have to be defined directly,
# in that case they will be taken from default values.
#
# Default values are defined in file onap/values.yaml (see-> global.certificate.default)
# and can be overriden during onap installation process.
#
*/}}

{{- define "common.certificate" -}}
{{- $dot := default . .dot -}}
{{- $certificates := $dot.Values.certificates -}}

{{ range $certificate := $certificates }}
{{/*# General certifiacate attributes  #*/}}
{{- $name           := $certificate.name                                                                          -}}
{{- $secretName     := $certificate.secretName                                                                    -}}
{{- $commonName     := default $dot.Values.global.certificate.default.commonName      $certificate.commonName     -}}
{{- $renewBefore    := default $dot.Values.global.certificate.default.renewBefore     $certificate.renewBefore    -}}
{{- $duration       := $certificate.duration                                                                      -}}
{{- $namespace      := default $dot.Release.Namespace         $dot.Values.global.certificate.default.namespace    -}}
{{- if $certificate.namespace -}}
{{-   $namespace    := default $namespace                                             $certificate.namespace      -}}
{{- end -}}
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
{{-   $organization := default $organization      $certificate.subject.organization       -}}
{{-   $country      := default $country           $certificate.subject.country            -}}
{{-   $locality     := default $locality          $certificate.subject.locality           -}}
{{-   $province     := default $province          $certificate.subject.province           -}}
{{-   $orgUnit      := default $orgUnit           $certificate.subject.organizationalUnit -}}
{{- end -}}
{{/*# Issuer #*/}}
{{- $issuerGroup    := $dot.Values.global.certificate.default.issuer.group    -}}
{{- $issuerKind     := $dot.Values.global.certificate.default.issuer.kind     -}}
{{- $issuerName     := $dot.Values.global.certificate.default.issuer.name     -}}
{{- if $certificate.issuer -}}
{{-   $issuerGroup  := default $issuerGroup    $certificate.issuer.group      -}}
{{-   $issuerKind   := default $issuerKind     $certificate.issuer.kind       -}}
{{-   $issuerName   := default $issuerName     $certificate.issuer.name       -}}
{{- end -}}
{{/*# Keystores #*/}}
{{- $createJksKeystore                  := $dot.Values.global.certificate.default.jksKeystore.create                  -}}
{{- $jksKeystorePasswordSecretName      := $dot.Values.global.certificate.default.jksKeystore.passwordSecretRef.name  -}}
{{- $jksKeystorePasswordSecreKey        := $dot.Values.global.certificate.default.jksKeystore.passwordSecretRef.key   -}}
{{- $createP12Keystore                  := $dot.Values.global.certificate.default.p12Keystore.create                  -}}
{{- $p12KeystorePasswordSecretName      := $dot.Values.global.certificate.default.p12Keystore.passwordSecretRef.name  -}}
{{- $p12KeystorePasswordSecreKey        := $dot.Values.global.certificate.default.p12Keystore.passwordSecretRef.key   -}}
{{- if $certificate.jksKeystore -}}
{{-   $createJksKeystore                := default $createJksKeystore                $certificate.jksKeystore.create                   -}}
{{-   $jksKeystorePasswordSecretName    := default $jksKeystorePasswordSecretName    $certificate.jksKeystore.passwordSecretRef.name   -}}
{{-   $jksKeystorePasswordSecreKey      := default $jksKeystorePasswordSecreKey      $certificate.jksKeystore.passwordSecretRef.key    -}}
{{- end -}}
{{- if $certificate.p12Keystore -}}
{{-   $createP12Keystore                := default $createP12Keystore                $certificate.p12Keystore.create                   -}}
{{-   $p12KeystorePasswordSecretName    := default $p12KeystorePasswordSecretName    $certificate.p12Keystore.passwordSecretRef.name   -}}
{{-   $p12KeystorePasswordSecreKey      := default $p12KeystorePasswordSecreKey      $certificate.p12Keystore.passwordSecretRef.key    -}}
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
      - {{ $dnsName }}
    {{- end }}
  {{- end }}
  {{- if $ipAddresses }}
  ipAddresses:
    {{- range $ipAddress := $ipAddresses }}
      - {{ $ipAddress }}
    {{- end }}
  {{- end }}
  {{- if $uris }}
  uris:
    {{- range $uri := $uris }}
      - {{ $uri }}
    {{- end }}
  {{- end }}
  {{- if $emailAddresses }}
  emailAddresses:
    {{- range $emailAddress := $emailAddresses }}
      - {{ $emailAddress }}
    {{- end }}
  {{- end }}
  issuerRef:
    group: {{ $issuerGroup }}
    kind:  {{ $issuerKind }}
    name:  {{ $issuerName }}
  keystores:
    jks:
      create: {{ $createJksKeystore }}
      passwordSecretRef:
        name: {{ $jksKeystorePasswordSecretName }}
        key:  {{ $jksKeystorePasswordSecreKey }}
    pkcs12:
      create: {{ $createP12Keystore }}
      passwordSecretRef:
        name: {{ $p12KeystorePasswordSecretName }}
        key:  {{ $p12KeystorePasswordSecreKey }}
{{ end }}

{{- end -}}
