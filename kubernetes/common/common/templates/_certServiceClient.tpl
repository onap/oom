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

{{- define "common.certServiceClient.initContainer" -}}
{{- $dot := default . .dot -}}
{{- if $dot.Values.common.global.cmpv2Enabled -}}
{{- $certificate := index $dot.Values.certificates 0 -}}
{{/*# General certifiacate attributes  #*/}}
{{- $commonName     := $certificate.commonName     -}}
{{/*# SAN's #*/}}
{{- $dnsNames       := default (list)    $certificate.dnsNames       -}}
{{- $ipAddresses    := default (list)    $certificate.ipAddresses    -}}
{{- $uris           := default (list)    $certificate.uris           -}}
{{- $emailAddresses := default (list)    $certificate.emailAddresses   -}}
{{- $sansList := concat $dnsNames $ipAddresses $uris $emailAddresses   -}}
{{- $sans := join "," $sansList }}
{{/*# Subject #*/}}
{{- $organization   := $dot.Values.common.global.certificate.default.subject.organization        -}}
{{- $country        := $dot.Values.common.global.certificate.default.subject.country             -}}
{{- $locality       := $dot.Values.common.global.certificate.default.subject.locality            -}}
{{- $province       := $dot.Values.common.global.certificate.default.subject.province            -}}
{{- $orgUnit        := $dot.Values.common.global.certificate.default.subject.organizationalUnit  -}}
{{- if $certificate.subject -}}
{{- $organization   := default $organization        $certificate.subject.organization -}}
{{- $country        := default $country             $certificate.subject.country -}}
{{- $locality       := default $locality            $certificate.subject.locality -}}
{{- $province       := default $province            $certificate.subject.province -}}
{{- $orgUnit        := default $orgUnit             $certificate.subject.organizationalUnit -}}
{{- end -}}
{{- $caName := $dot.Values.common.global.platform.certServiceClient.envVariables.caName -}}
{{- $outputType := $dot.Values.common.global.platform.certServiceClient.envVariables.outputType -}}
{{- $image := $dot.Values.common.global.platform.certServiceClient.image -}}
{{- $requestUrl := $dot.Values.common.global.platform.certServiceClient.envVariables.requestUrl -}}
{{- $certPath := $dot.Values.common.global.platform.certServiceClient.envVariables.certPath -}}
{{- $requestTimeout := $dot.Values.common.global.platform.certServiceClient.envVariables.requestTimeout -}}
{{- $certificatesSecretMountPath := $dot.Values.common.global.platform.certServiceClient.secret.mountPath -}}
{{- $keystorePath := $dot.Values.common.global.platform.certServiceClient.envVariables.keystorePath -}}
{{- $keystorePassword := $dot.Values.common.global.platform.certServiceClient.envVariables.keystorePassword -}}
{{- $truststorePath := $dot.Values.common.global.platform.certServiceClient.envVariables.truststorePath -}}
{{- $truststorePassword := $dot.Values.common.global.platform.certServiceClient.envVariables.truststorePassword -}}
- name: certs-init
  image: {{ include "repositoryGenerator.repository" . }}/{{ $image }}
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  env:
    - name: REQUEST_URL
      value: {{ $requestUrl }}
    - name: REQUEST_TIMEOUT
      value: {{ $requestTimeout }}
    - name: OUTPUT_PATH
      value: {{ $certPath }}
    - name: CA_NAME
      value: {{ $caName }}
    - name: COMMON_NAME
      value: {{ $commonName }}
    - name: SANS
      value: {{ $sans }}
    - name: ORGANIZATION
      value: {{ $organization }}
    - name: ORGANIZATION_UNIT
      value: {{ $orgUnit }}
    - name: LOCATION
      value: {{ $locality }}
    - name: STATE
      value: {{ $province }}
    - name: COUNTRY
      value: {{ $country }}
    - name: KEYSTORE_PATH
      value: {{ $keystorePath }}
    - name: KEYSTORE_PASSWORD
      value: {{ $keystorePassword }}
    - name: TRUSTSTORE_PATH
      value: {{ $truststorePath }}
    - name: TRUSTSTORE_PASSWORD
      value: {{ $truststorePassword }}
  terminationMessagePath: /dev/termination-log
  terminationMessagePolicy: File
  volumeMounts:
    - mountPath: {{ $certPath }}
      name: cmpv2-certs-volume
    - mountPath: {{ $certificatesSecretMountPath }}
      name: certservice-tls-volume
{{- end -}}
{{- end -}}

{{- define "common.certServiceClient.volumes" -}}
{{- $dot := default . .dot -}}
{{- if $dot.Values.common.global.cmpv2Enabled -}}
  {{- $certificatesSecretName := $dot.Values.common.global.platform.certServiceClient.secret.name -}}
- name: cmpv2-certs-volume
  emptyDir:
    medium: Memory
- name: certservice-tls-volume
  secret:
    secretName: {{ $certificatesSecretName }}
{{- end -}}
{{- end -}}

{{- define "common.certServiceClient.volumeMounts" -}}
{{- $dot := default . .dot -}}
{{- if $dot.Values.common.global.cmpv2Enabled -}}
  {{- $certificate := index $dot.Values.certificates 0 -}}
  {{- $mountPath := $certificate.mountPath -}}
- mountPath: {{ $mountPath }}
  name: cmpv2-certs-volume
{{- end -}}
{{- end -}}
