{{/*
# Copyright © 2020 Amdocs, Bell Canada, highstreet technologies GmbH
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
  common templates to enable aaf configs for applictaions

  Parameter for aafConfig to be defined in values.yaml
  aafConfig:   --> if a different key is used, call templates with argument (dict "aafRoot" .Values.<yourkey> "dot" .)
    # additional scripts can be defined to handle certs
    addconfig: true|false
    fqdn: "sdnc"
    app_ns: "org.osaaf.aaf"
    fqi: "sdnc@sdnc.onap.org"
    fqi_namespace: org.onap.sdnc
    public_fqdn: "aaf.osaaf.org"
    aafDeployFqi: "deployer@people.osaaf.org"
    aafDeployPass: demo123456!
    cadi_latitude: "38.0"
    cadi_longitude: "-72.0"
    secret_uid: &aaf_secret_uid my-component-aaf-deploy-creds

  # secrets configuration, Note: create a secrets template
  secrets:
    - uid: *aaf_secret_uid
      type: basicAuth
      externalSecret: '{{ ternary (tpl (default "" .Values.aafConfig.aafDeployCredsExternalSecret) .) "aafIsDisabled" .Values.global.aafEnabled }}'
      login: '{{ .Values.aafConfig.aafDeployFqi }}'
      password: '{{ .Values.aafConfig.aafDeployPass }}'
      passwordPolicy: required

  In deployments/jobs/stateful include:
  initContainers:
    {{ include "common.aaf-config" . | nindent XX}}

  containers:
    volumeMounts:
    {{- if .Values.global.aafEnabled }}
     - mountPath: "/opt/app/osaaf"
       name: {{ include "common.fullname" . }}-aaf-config
       {{- end }}
  volumes:
  {{- include "common.aaf-config-volumes" . | nindent XX}}
*/}}
{{- define "common.aaf-config" -}}
{{-   $dot := default . .dot -}}
{{-   $aafRoot := default $dot.Values.aafConfig .aafRoot -}}
{{-   if $dot.Values.global.aafEnabled -}}
- name: {{ include "common.name" $dot }}-aaf-readiness
  image: {{ include "common.repository" $dot }}/{{ $dot.Values.global.readinessImage }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  command:
  - /app/ready.py
  args:
  - --container-name
  - aaf-locate
  - --container-name
  - aaf-cm
  - --container-name
  - aaf-service
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
  resources:
    limits:
      cpu: 100m
      memory: 100Mi
    requests:
      cpu: 3m
      memory: 20Mi
- name: {{ include "common.name" $dot }}-aaf-config
  image: {{ (default $dot.Values.repository $dot.Values.global.repository) }}/{{ $dot.Values.global.aafAgentImage }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  volumeMounts:
  - mountPath: "/opt/app/osaaf"
    name: {{ include "common.fullname" $dot }}-aaf-config
{{-     if $aafRoot.addconfig }}
  - name: aaf-add-config
    mountPath: /opt/app/aaf_config/bin/aaf-add-config.sh
    subPath: aaf-add-config.sh
{{-     end }}
  command:
    - sh
    - -c
    - |
      #!/usr/bin/env bash
      /opt/app/aaf_config/bin/agent.sh
{{-     if $aafRoot.addconfig }}
      /opt/app/aaf_config/bin/aaf-add-config.sh
{{-     end }}
  env:
    - name: APP_FQI
      value: "{{ $aafRoot.fqi }}"
    - name: aaf_locate_url
      value: "https://aaf-locate.{{ $dot.Release.Namespace}}:8095"
    - name: aaf_locator_container
      value: "oom"
    - name: aaf_locator_container_ns
      value: "{{ $dot.Release.Namespace }}"
    - name: aaf_locator_fqdn
      value: "{{ $aafRoot.fqdn }}"
    - name: aaf_locator_app_ns
      value: "{{ $aafRoot.app_ns }}"
    - name: DEPLOY_FQI
    {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" $aafRoot.secret_uid "key" "login") | indent 6 }}
    - name: DEPLOY_PASSWORD
    {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" $aafRoot.secret_uid "key" "password") | indent 6 }}
  #Note: want to put this on Nodes, eventually
    - name: cadi_longitude
      value: "{{ default "52.3" $aafRoot.cadi_longitude }}"
    - name: cadi_latitude
      value: "{{ default "13.2" $aafRoot.cadi_latitude }}"
  #Hello specific.  Clients don't don't need this, unless Registering with AAF Locator
    - name: aaf_locator_public_fqdn
      value: "{{ $aafRoot.public_fqdn | default "" }}"
  resources:
    limits:
      cpu: 100m
      memory: 100Mi
    requests:
      cpu: 3m
      memory: 20Mi
{{-   end -}}
{{- end -}}

{{- define "common.aaf-config-volume-mountpath" -}}
{{-   if .Values.global.aafEnabled -}}
- mountPath: "/opt/app/osaaf"
  name: {{ include "common.fullname" . }}-aaf-config
{{-   end -}}
{{- end -}}

{{- define "common.aaf-config-volumes" -}}
{{-   $dot := default . .dot -}}
{{-   $aafRoot := default $dot.Values.aafConfig .aafRoot -}}
{{-   if $dot.Values.global.aafEnabled -}}
- name: {{ include "common.fullname" $dot }}-aaf-config
  emptyDir:
    medium: Memory
{{-     if $aafRoot.addconfig }}
- name: aaf-add-config
  configMap:
    name: {{ include "common.fullname" $dot }}-aaf-add-config
    defaultMode: 0700
{{-     end -}}
{{-   end -}}
{{- end -}}
