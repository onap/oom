{{/*
# Copyright © 2021 Nokia
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
In order to use certServiceClient it is needed do define certificates array in target component values.yaml. Each
certificate will be requested from separate init container

Minimum example of array in target component values.yaml:
certificates:
  - mountPath:  /var/custom-certs
    commonName: common-name

Full example (other fields are ignored):
certificates:
  - mountPath:  /var/custom-certs
    caName: RA
    outputType: JKS
    commonName: common-name
    dnsNames:
      - dns-name-1
      - dns-name-2
    ipAddresses:
      - 192.168.0.1
      - 192.168.0.2
    emailAddresses:
      - email-1@onap.org
      - email-2@onap.org
    uris:
      - http://uri-1.onap.org
      - http://uri-2.onap.org
    subject:
      organization: Linux-Foundation
      country: US
      locality: San Francisco
      province: California
      organizationalUnit: ONAP

There also need to be some includes used in a target component deployment (indent values may need to be adjusted):
  1. In initContainers section:
    {{ include "common.certServiceClient.initContainer" . | indent 6 }}
  2. In volumeMounts section of container using certificates:
    {{ include "common.certServiceClient.volumeMounts" . | indent 10 }}
  3. In volumes section:
    {{ include "common.certServiceClient.volumes" . | indent 8 }}

*/}}

{{- define "common.certServiceClient.initContainer" -}}
{{- $dot := default . .dot -}}
{{- $initRoot := default $dot.Values.cmpv2Certificate .initRoot -}}
{{- $subchartGlobal := mergeOverwrite (deepCopy $initRoot.global) $dot.Values.global -}}
{{- if and $subchartGlobal.cmpv2Enabled (not $subchartGlobal.CMPv2CertManagerIntegration) -}}
{{- range $index, $certificate := $dot.Values.certificates -}}
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
{{- $organization   := $subchartGlobal.certificate.default.subject.organization        -}}
{{- $country        := $subchartGlobal.certificate.default.subject.country             -}}
{{- $locality       := $subchartGlobal.certificate.default.subject.locality            -}}
{{- $province       := $subchartGlobal.certificate.default.subject.province            -}}
{{- $orgUnit        := $subchartGlobal.certificate.default.subject.organizationalUnit  -}}
{{- if $certificate.subject -}}
{{- $organization   := $certificate.subject.organization -}}
{{- $country        := $certificate.subject.country -}}
{{- $locality       := $certificate.subject.locality -}}
{{- $province       := $certificate.subject.province -}}
{{- $orgUnit        := $certificate.subject.organizationalUnit -}}
{{- end -}}
{{- $caName := default $subchartGlobal.platform.certServiceClient.envVariables.caName $certificate.caName -}}
{{- $outputType := default $subchartGlobal.platform.certServiceClient.envVariables.outputType  $certificate.outputType  -}}
{{- $requestUrl := $subchartGlobal.platform.certServiceClient.envVariables.requestURL -}}
{{- $certPath := $subchartGlobal.platform.certServiceClient.envVariables.certPath -}}
{{- $requestTimeout := $subchartGlobal.platform.certServiceClient.envVariables.requestTimeout -}}
{{- $certificatesSecretMountPath := $subchartGlobal.platform.certServiceClient.secret.mountPath -}}
{{- $keystorePath := $subchartGlobal.platform.certServiceClient.envVariables.keystorePath -}}
{{- $keystorePassword := $subchartGlobal.platform.certServiceClient.envVariables.keystorePassword -}}
{{- $truststorePath := $subchartGlobal.platform.certServiceClient.envVariables.truststorePath -}}
{{- $truststorePassword := $subchartGlobal.platform.certServiceClient.envVariables.truststorePassword -}}
- name: certs-init-{{ $index }}
  image: {{ include "repositoryGenerator.image.certserviceclient" $dot }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  env:
    - name: REQUEST_URL
      value: {{ $requestUrl | quote }}
    - name: REQUEST_TIMEOUT
      value: {{ $requestTimeout | quote }}
    - name: OUTPUT_PATH
      value: {{ $certPath | quote }}
    - name: OUTPUT_TYPE
      value: {{ $outputType | quote }}
    - name: CA_NAME
      value: {{ $caName | quote }}
    - name: COMMON_NAME
      value: {{ $commonName | quote }}
    - name: SANS
      value: {{ $sans | quote }}
    - name: ORGANIZATION
      value: {{ $organization | quote }}
    - name: ORGANIZATION_UNIT
      value: {{ $orgUnit | quote }}
    - name: LOCATION
      value: {{ $locality | quote }}
    - name: STATE
      value: {{ $province | quote }}
    - name: COUNTRY
      value: {{ $country | quote }}
    - name: KEYSTORE_PATH
      value: {{ $keystorePath | quote }}
    - name: KEYSTORE_PASSWORD
      value: {{ $keystorePassword | quote }}
    - name: TRUSTSTORE_PATH
      value: {{ $truststorePath | quote }}
    - name: TRUSTSTORE_PASSWORD
      value: {{ $truststorePassword | quote }}
  terminationMessagePath: /dev/termination-log
  terminationMessagePolicy: File
  volumeMounts:
    - mountPath: {{ $certPath }}
      name: cmpv2-certs-volume-{{ $index }}
    - mountPath: {{ $certificatesSecretMountPath }}
      name: certservice-tls-volume
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "common.certServiceClient.volumes" -}}
{{- $dot := default . .dot -}}
{{- $initRoot := default $dot.Values.cmpv2Certificate .initRoot -}}
{{- $subchartGlobal := mergeOverwrite (deepCopy $initRoot.global) $dot.Values.global -}}
{{- if and $subchartGlobal.cmpv2Enabled (not $subchartGlobal.CMPv2CertManagerIntegration) -}}
{{- $certificatesSecretName := $subchartGlobal.platform.certServiceClient.secret.name -}}
- name: certservice-tls-volume
  secret:
    secretName: {{ $certificatesSecretName }}
{{ range $index, $certificate := $dot.Values.certificates -}}
- name: cmpv2-certs-volume-{{ $index }}
  emptyDir:
    medium: Memory
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "common.certServiceClient.volumeMounts" -}}
{{- $dot := default . .dot -}}
{{- $initRoot := default $dot.Values.cmpv2Certificate .initRoot -}}
{{- $subchartGlobal := mergeOverwrite (deepCopy $initRoot.global) $dot.Values.global -}}
{{- if and $subchartGlobal.cmpv2Enabled (not $subchartGlobal.CMPv2CertManagerIntegration) -}}
{{- range $index, $certificate := $dot.Values.certificates -}}
{{- $mountPath := $certificate.mountPath -}}
- mountPath: {{ $mountPath }}
  name: cmpv2-certs-volume-{{ $index }}
{{ end -}}
{{- end -}}
{{- end -}}
