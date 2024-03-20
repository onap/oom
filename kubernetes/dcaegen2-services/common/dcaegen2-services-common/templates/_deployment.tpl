{{/*
#============LICENSE_START========================================================
# ================================================================================
# Copyright (c) 2021-2023 J. F. Lucas. All rights reserved.
# Copyright (c) 2021 AT&T Intellectual Property. All rights reserved.
# Copyright (c) 2021 Nokia. All rights reserved.
# Copyright (c) 2021 Nordix Foundation.
# ================================================================================
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
# ============LICENSE_END=========================================================
*/}}
{{/*
For internal use only!

dcaegen2-services-common._ms-specific-env-vars:
This template generates a list of microservice-specific environment variables
as specified in .Values.applicationEnv.  The
dcaegen2-services-common.microServiceDeployment uses this template
to add the microservice-specific environment variables to the microservice's container.
These environment variables are in addition to a standard set of environment variables
provided to all microservices.

The template expects a single argument, pointing to the caller's global context.

Microservice-specific environment variables can be specified in two ways:
  1. As literal string values. (The values can also be Helm template fragments.)
  2. As values that are sourced from a secret, identified by the secret's
     uid and the key within the secret that provides the value.

The following example shows an example of each type.  The example assumes
that a secret has been created using the OOM common secret mechanism, with
a secret uid "example-secret" and a key called "password".

applicationEnv:
  APPLICATION_PASSWORD:
    secretUid: example-secret
    key: password
  APPLICATION_EXAMPLE: "An example value"

The example would set two environment variables on the microservice's container,
one called "APPLICATION_PASSWORD" with the value set from the "password" key in
the secret with uid "example-secret", and one called "APPLICATION_EXAMPLE" set to
the the literal string "An example value".
*/}}
{{- define "dcaegen2-services-common._ms-specific-env-vars" -}}
  {{- $global := . }}
  {{- if .Values.applicationEnv }}
    {{- range $envName, $envValue := .Values.applicationEnv }}
      {{- if kindIs "string" $envValue }}
- name: {{ $envName }}
  value: {{ tpl $envValue $global | quote }}
      {{- else }}
        {{- if and (hasKey $envValue "externalSecret") ($envValue.externalSecret) }}
- name: {{ $envName }}
  valueFrom:
    secretKeyRef:
      name: {{ tpl $envValue.externalSecretUid $global | quote }}
      key: {{ tpl $envValue.key $global | quote }}
        {{- else }}
          {{ if or (not $envValue.secretUid) (not $envValue.key) }}
            {{ fail (printf "Env %s definition is not a string and does not contain secretUid or key fields" $envName) }}
          {{- end }}
- name: {{ $envName }}
  {{- include "common.secret.envFromSecretFast" (dict "global" $global "uid" $envValue.secretUid "key" $envValue.key) | indent 2 }}
        {{- end }}
      {{- end -}}
    {{- end }}
  {{- end }}
{{- end -}}
{{/*
For internal use only!

dcaegen2-services-common._externalVolumes:
This template generates a list of volumes associated with the pod,
based on information provided in .Values.externalVolumes.  This
template works in conjunction with dcaegen2-services-common._externalVolumeMounts
to give the microservice access to data in volumes created else.
This initial implementation supports ConfigMaps only, as this is the only
external volume mounting required by current microservices.

.Values.externalVolumes is a list of objects.  Each object has 3 required fields and 2 optional fields:
   - name: the name of the resource (in the current implementation, it must be a ConfigMap)
     that is to be set up as a volume.  The value is a case sensitive string.  Because the
     names of resources are sometimes set at deployment time (for instance, to prefix the Helm
     release to the name), the string can be a Helm template fragment that will be expanded at
     deployment time.
   - type: the type of the resource (in the current implementation, only "ConfigMap" is supported).
     The value is a case-INsensitive string.
   - mountPoint: the path to the mount point for the volume in the container file system.  The
     value is a case-sensitive string.
   - readOnly: (Optional) Boolean flag.  Set to true to mount the volume as read-only.
     Defaults to false.
   - optional: (Optional) Boolean flag.  Set to true to make the configMap optional (i.e., to allow the
     microservice's pod to start even if the configMap doesn't exist).  If set to false, the configMap must
     be present in order for the microservice's pod to start. Defaults to true.  (Note that this
     default is the opposite of the Kubernetes default.  We've done this to be consistent with the behavior
     of the DCAE Cloudify plugin for Kubernetes [k8splugin], which always set "optional" to true.)

Here is an example fragment from a values.yaml file for a microservice:

externalVolumes:
  - name: my-example-configmap
    type: configmap
    mountPath: /opt/app/config
  - name: '{{ include "common.release" . }}-another-example'
    type: configmap
    mountPath: /opt/app/otherconfig
    optional: false
*/}}
{{- define "dcaegen2-services-common._externalVolumes" -}}
  {{- $global := . -}}
  {{- if .Values.externalVolumes }}
    {{- range $vol := .Values.externalVolumes }}
      {{- if eq (lower $vol.type) "configmap" }}
        {{- $vname := (tpl $vol.name $global) -}}
        {{- $opt := hasKey $vol "optional" | ternary $vol.optional true }}
- configMap:
    defaultMode: 420
    name: {{ $vname }}
    optional: {{ $opt }}
  name: {{ $vname }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{/*
For internal use only!

dcaegen2-services-common._externalVolumeMounts:
This template generates a list of volume mounts for the microservice container,
based on information provided in .Values.externalVolumes.  This
template works in conjunction with dcaegen2-services-common._externalVolumes
to give the microservice access to data in volumes created else.
This initial implementation supports ConfigMaps only, as this is the only
external volume mounting required by current microservices.

See the documentation for dcaegen2-services-common._externalVolumes for
details on how external volumes are specified in the values.yaml file for
the microservice.
*/}}
{{- define "dcaegen2-services-common._externalVolumeMounts" -}}
  {{- $global := . -}}
  {{- if .Values.externalVolumes }}
    {{- range $vol := .Values.externalVolumes }}
      {{- if eq (lower $vol.type) "configmap" }}
        {{- $vname := (tpl $vol.name $global) -}}
        {{- $readOnly := $vol.readOnly | default false }}
- mountPath: {{ $vol.mountPath }}
  name: {{ $vname }}
  readOnly: {{ $readOnly }}
      {{- end }}
    {{- end }}
  {{- end }}
{{- end }}
{{/*
dcaegen2-services-common.microserviceDeployment:
This template produces a Kubernetes Deployment for a DCAE microservice.

All DCAE microservices currently use very similar Deployments.  Having a
common template eliminates a lot of repetition in the individual charts
for each microservice.

The template expects the full chart context as input.  A chart for a
DCAE microservice references this template using:
{{ include "dcaegen2-services-common.microserviceDeployment" . }}
The template directly references data in .Values, and indirectly (through its
use of templates from the ONAP "common" collection) references data in
.Release.

The exact content of the Deployment generated from this template
depends on the content of .Values.

The Deployment always includes a single Pod, with a container that uses
the DCAE microservice image.  The image name and tag are specified by
.Values.image.  By default, the image comes from the ONAP repository
(registry) set up by the common repositoryGenerator template.  A different
repository for the microservice image can be set using
.Values.imageRepositoryOverride.   Note that this repository must not
require authentication, because there is no way to specify credentials for
the override repository.  imageRepositoryOverride is intended primarily
for testing purposes.

The Deployment Pod may also include a logging sidecar container.
The sidecar is included if .Values.log.path is set.  The
logging sidecar and the DCAE microservice container share a
volume where the microservice logs are written.

Deployed POD may also include a Policy-sync sidecar container.
The sidecar is included if .Values.policies is set.  The
Policy-sync sidecar polls PolicyEngine (PDP) periodically based
on .Values.policies.duration and configuration retrieved is shared with
DCAE Microservice container by common volume. Policy can be retrieved based on
list of policyID or filter. An optional policyRelease parameter can be specified
to override the default policy helm release (used for retreiving the secret containing
pdp username and password)

Following is example policy config override

dcaePolicySyncImage: onap/org.onap.dcaegen2.deployments.dcae-services-policy-sync:1.0.1
policies:
  duration: 300
  policyRelease: "onap"
  policyID: |
    '["onap.vfirewall.tca","onap.vdns.tca"]'

The Deployment includes an initContainer that checks for the
readiness of other components that the microservice relies on.
This container is generated by the "common.readinessCheck.waitfor"
template. See the documentation for this template
(oom/kubernetes/common/readinessCheck/templates/_readinessCheck.tpl).

If the microservice uses a DMaaP Data Router (DR) feed, the Deployment
includes an initContainer that makes provisioning requests to the DMaaP
bus controller (dmaap-bc) to create the feed and to set up a publisher
and/or subscriber to the feed.  The Deployment also includes a second
initContainer that merges the information returned by the provisioning
process into the microservice's configuration.  See the documentation for
the common DMaaP provisioning template
(oom/kubernetes/common/common/templates/_dmaapProvisioning.tpl).

If the microservice uses certificates from an external CMPv2 provider,
the Deployment will include an initContainer that performs certificate
post-processing.
*/}}

{{- define "dcaegen2-services-common.microserviceDeployment" -}}
{{- $log := default dict .Values.log -}}
{{- $logDir :=  default "" $log.path -}}
{{- $certDir := (eq "true" (include "common.needTLS" .)) | ternary (default "" .Values.certDirectory . ) "" -}}
{{- $commonRelease :=  print (include "common.release" .) -}}
{{- $policy := default dict .Values.policies -}}
{{- $policyRls := default $commonRelease $policy.policyRelease -}}
{{- $drNeedProvisioning := or .Values.drFeedConfig .Values.drSubConfig -}}
{{- $dcaeName := print (include "common.fullname" .) }}
{{- $dcaeLabel := (dict "dcaeMicroserviceName" $dcaeName) -}}
{{- $dot := . -}}
apiVersion: apps/v1
kind: Deployment
metadata: {{- include "common.resourceMetadata" (dict "dot" $dot "labels" $dcaeLabel) | nindent 2 }}
spec:
  replicas: 1
  selector: {{- include "common.selectors" . | nindent 4 }}
  template:
    metadata: {{- include "common.templateMetadata" . | nindent 6 }}
    spec:
      initContainers:
      {{- if .Values.readinessCheck }}
      {{ include "common.readinessCheck.waitFor" . | indent 6 | trim }}
      {{- end }}
      {{- include "common.dmaap.provisioning.initContainer" . | nindent 6 }}
      {{ include "dcaegen2-services-common._certPostProcessor" .  | nindent 4 }}
      containers:
      - image: {{ default ( include "repositoryGenerator.repository" . ) .Values.imageRepositoryOverride }}/{{ .Values.image }}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        name: {{ include "common.name" . }}
        env:
        {{- range $cred := .Values.credentials }}
        - name: {{ $cred.name }}
          {{- include "common.secret.envFromSecretFast" (dict "global" $ "uid" $cred.uid "key" $cred.key) | indent 10 }}
        {{- end }}
        {{- if $certDir }}
        - name: DCAE_CA_CERTPATH
          value: {{ $certDir }}/cacert.pem
        {{- end }}
        - name: CONSUL_HOST
          value: consul-server.onap
        - name: CONFIG_BINDING_SERVICE
          value: config-binding-service
        - name: CBS_CONFIG_URL
          value: https://config-binding-service:10443/service_component_all/{{ include "common.name" . }}
        - name: POD_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
        {{- include "dcaegen2-services-common._ms-specific-env-vars" . | nindent 8 }}
        {{- if .Values.service }}
        ports: {{ include "common.containerPorts" . | nindent 10 }}
        {{- end }}
        {{- if .Values.readiness }}
        readinessProbe:
          initialDelaySeconds: {{ .Values.readiness.initialDelaySeconds | default 5 }}
          periodSeconds: {{ .Values.readiness.periodSeconds | default 15 }}
          timeoutSeconds: {{ .Values.readiness.timeoutSeconds | default 1 }}
          {{- $probeType := .Values.readiness.type | default "httpGet" -}}
          {{- if eq $probeType "httpGet" }}
          httpGet:
            scheme: {{ .Values.readiness.scheme }}
            path: {{ .Values.readiness.path }}
            port: {{ .Values.readiness.port }}
          {{- end }}
          {{- if eq $probeType "exec" }}
          exec:
            command:
            {{- range $cmd := .Values.readiness.command }}
            - {{ $cmd }}
            {{- end }}
          {{- end }}
        {{- end }}
        resources: {{ include "common.resources" . | nindent 10 }}
        volumeMounts:
        - mountPath: /app-config
          name: {{ ternary "app-config-input" "app-config" (not $drNeedProvisioning) }}
        - mountPath: /app-config-input
          name: app-config-input
        {{- if $logDir }}
        - mountPath: {{ $logDir}}
          name: logs
        {{- end }}
        {{- if $certDir }}
        - mountPath: {{ $certDir }}
          name: tls-info
          {{- if (include "dcaegen2-services-common.shouldUseCmpv2Certificates" .) -}}
          {{- include "common.certManager.volumeMountsReadOnly" . | nindent 8 -}}
          {{- end -}}
        {{- end }}
        {{- if $policy }}
        - name: policy-shared
          mountPath: /etc/policies
        {{- end }}
        {{- include "dcaegen2-services-common._externalVolumeMounts" . | nindent 8 }}
      {{- if $logDir }}
      {{ include "common.log.sidecar" . | nindent 6 }}
      {{- end }}
      {{- if $policy }}
      - image: {{ include "repositoryGenerator.repository" . }}/{{ .Values.dcaePolicySyncImage }}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        name: policy-sync
        env:
        - name: POD_IP
          valueFrom:
            fieldRef:
              apiVersion: v1
              fieldPath: status.podIP
        - name: POLICY_SYNC_PDP_USER
          valueFrom:
            secretKeyRef:
              name: {{ $policyRls }}-policy-xacml-pdp-restserver-creds
              key: login
        - name: POLICY_SYNC_PDP_PASS
          valueFrom:
            secretKeyRef:
              name: {{ $policyRls }}-policy-xacml-pdp-restserver-creds
              key: password
        - name: POLICY_SYNC_PDP_URL
          value : http{{ if (include "common.needTLS" .) }}s{{ end }}://policy-xacml-pdp:6969
        - name: POLICY_SYNC_OUTFILE
          value : "/etc/policies/policies.json"
        - name: POLICY_SYNC_V1_DECISION_ENDPOINT
          value : "policy/pdpx/v1/decision"
        {{- if $policy.filter }}
        - name: POLICY_SYNC_FILTER
          value: {{ $policy.filter }}
        {{- end -}}
        {{- if $policy.policyID }}
        - name: POLICY_SYNC_ID
          value: {{ $policy.policyID }}
        {{- end -}}
        {{- if $policy.duration }}
        - name: POLICY_SYNC_DURATION
          value: "{{ $policy.duration }}"
        {{- end }}
        resources: {{ include "common.resources" . | nindent 10 }}
        volumeMounts:
        - mountPath: /etc/policies
          name: policy-shared
      {{- end }}
      hostname: {{ include "common.name" . }}
      serviceAccountName: {{ include "common.fullname" (dict "suffix" "read" "dot" . )}}
      volumes:
      - configMap:
          defaultMode: 420
          name: {{ include "common.fullname" . }}-application-config-configmap
        name: app-config-input
      - emptyDir:
          medium: Memory
        name: app-config
      {{- if $logDir }}
      - emptyDir: {}
        name: logs
      {{ include "common.log.volumes" (dict "dot" . "configMapNamePrefix" (tpl .Values.logConfigMapNamePrefix . )) | nindent 6 }}
      {{- end }}
      {{- if $certDir }}
      - emptyDir: {}
        name: tls-info
        {{ if (include "dcaegen2-services-common.shouldUseCmpv2Certificates" .) -}}
        {{ include "common.certManager.volumesReadOnly" . | nindent 6 }}
        {{- end }}
      {{- end }}
      {{- if $policy }}
      - name: policy-shared
        emptyDir: {}
      {{- end }}
      {{- include "common.dmaap.provisioning._volumes" . | nindent 6 -}}
      {{- include "dcaegen2-services-common._externalVolumes" . | nindent 6 }}
      {{- include "common.imagePullSecrets" . | nindent 6 }}
{{ end -}}

{{/*
  For internal use

  Template to attach CertPostProcessor which merges CMPv2 truststore with AAF truststore
  and swaps keystore files.
*/}}
{{- define "dcaegen2-services-common._certPostProcessor" -}}
  {{- $certDir := default "" .Values.certDirectory . -}}
  {{- if (include "dcaegen2-services-common.shouldUseCmpv2Certificates" .) -}}
    {{- $cmpv2Certificate := (index .Values.certificates 0) -}}
    {{- $cmpv2CertificateDir := $cmpv2Certificate.mountPath -}}
    {{- $certType := "pem" -}}
    {{- if $cmpv2Certificate.keystore -}}
      {{- $certType = (index $cmpv2Certificate.keystore.outputType 0) -}}
    {{- end -}}
    {{- $truststoresPaths := printf "%s/%s:%s/%s" $certDir "cacert.pem" $cmpv2CertificateDir "cacert.pem" -}}
    {{- $truststoresPasswordPaths := ":" -}}
    {{- $keystoreSourcePaths := printf "%s/%s:%s/%s" $cmpv2CertificateDir "cert.pem" $cmpv2CertificateDir "key.pem" -}}
    {{- $keystoreDestinationPaths := printf "%s/%s:%s/%s" $certDir "cert.pem" $certDir "key.pem" -}}
    {{- if not (eq $certType "pem") -}}
      {{- $truststoresPaths = printf "%s/%s:%s/%s.%s" $certDir "trust.jks" $cmpv2CertificateDir "truststore" $certType -}}
      {{- $truststoresPasswordPaths = printf "%s/%s:%s/%s" $certDir "trust.pass" $cmpv2CertificateDir "truststore.pass" -}}
      {{- $keystoreSourcePaths = printf "%s/%s.%s:%s/%s" $cmpv2CertificateDir "keystore" $certType $cmpv2CertificateDir "keystore.pass" -}}
      {{- $keystoreDestinationPaths = printf "%s/%s.%s:%s/%s.pass" $certDir "cert" $certType $certDir $certType -}}
    {{- end }}
  - name: cert-post-processor
    image: {{ include "repositoryGenerator.repository" . }}/{{ .Values.certPostProcessorImage }}
    imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
    resources:
      {{- include "common.resources" . | nindent 4 }}
    volumeMounts:
    - mountPath: {{ $certDir }}
      name: tls-info
      {{- include "common.certManager.volumeMountsReadOnly" . | nindent 4 }}
    env:
    - name: TRUSTSTORES_PATHS
      value: {{ $truststoresPaths | quote}}
    - name: TRUSTSTORES_PASSWORDS_PATHS
      value: {{ $truststoresPasswordPaths | quote }}
    - name: KEYSTORE_SOURCE_PATHS
      value: {{ $keystoreSourcePaths | quote }}
    - name: KEYSTORE_DESTINATION_PATHS
      value: {{ $keystoreDestinationPaths | quote }}
  {{- end }}
{{- end -}}

{{/*
  Template returns string "true" if CMPv2 certificates should be used and nothing (so it can be used in with statements)
  when they shouldn't. Example use:
    {{- if (include "dcaegen2-services-common.shouldUseCmpv2Certificates" .) -}}

*/}}
{{- define "dcaegen2-services-common.shouldUseCmpv2Certificates" -}}
  {{- $certDir := default "" .Values.certDirectory . -}}
  {{- if (and $certDir .Values.certificates .Values.global.cmpv2Enabled .Values.useCmpv2Certificates) -}}
  true
  {{- end -}}
{{- end -}}
