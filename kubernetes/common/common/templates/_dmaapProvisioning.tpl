{{/*
################################################################################
#   Copyright (C) 2021 Nordix Foundation.                                      #
#   Copyright (c) 2022-2023 J. F. Lucas.  All rights reserved.                      #
#                                                                              #
#   Licensed under the Apache License, Version 2.0 (the "License");            #
#   you may not use this file except in compliance with the License.           #
#   You may obtain a copy of the License at                                    #
#                                                                              #
#       http://www.apache.org/licenses/LICENSE-2.0                             #
#                                                                              #
#   Unless required by applicable law or agreed to in writing, software        #
#   distributed under the License is distributed on an "AS IS" BASIS,          #
#   WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.   #
#   See the License for the specific language governing permissions and        #
#   limitations under the License.                                             #
################################################################################
*/}}

{{/*
  This template generates a Kubernetes init containers common template to enable applications to provision
  DMaaP feeds (on Data Router) for DCAE microservices, with associated authorization.
  DMaap Data Router (DR) endpoints are used to provision:
  - Feeds on DR, with associated user authentication.
  - Subscribers to feeds on DR, to provide DR with username, password, and URL needed to deliver
    files to subscribers.

  common.dmaap.provisioning.initContainer:
  This template creates an initContainer with some associated volumes.  The initContainer
  (oom/kubernetes/dmaap-datarouter/drprov-client) runs a script (drprov-client.sh) that uses the
  DR provisioning API to create the feeds and subscribers needed by a microservice.  The script
  updates the microservice's configuration to supply information needed to access the feeds. The
  configuration information comes from two volumes that are created by the dcaegen2-services-common
  templates.
  - app-config-input: comes from a configMap generated from the microservice's values.yaml file.
    It may contain references to environment variables as placeholders for feed information that
    will become available after feeds are provisioned.
  - app-config: this template will copy the configuration file from the app-config-input volume,
    replaced the environment variable references with the actual values for feed information, based
    on data returned by the DR provisioning API.

  The template directly references data in .Values, and indirectly (through its
  use of templates from the ONAP "common" collection) references data in .Release.

  Parameters for _dmaapProvisioning to be defined in values.yaml:

  # DataRouter Feed Configuration
  # (Note that DR configures publishers as part of the feed.)
  drFeedConfig:
    - feedName: bulk_pm_feed
      feedVersion: 0.0
      classification: unclassified
      feedDescription: DFC Feed Creation
      publisher:
        username: xyz
        password: xyz

  # DataRouter Subscriber Configuration
  drSubConfig:
    - feedName: bulk_pm_feed
      feedVersion: 0.0
      decompress: True
      privilegedSubscriber: True
      deliveryURL: https://dcae-pm-mapper:8443/delivery

  # ConfigMap Configuration for DR Feed, Dr_Subscriber
  volumes:
    - name: feeds-config
      path: /opt/app/config/feeds
    - name: drsub-config
      path: /opt/app/config/dr_subs

  In deployments/jobs/stateful include:
  initContainers:
  {{- include "common.dmaap.provisioning.initContainer" . | nindent XX }}
  volumes:
  {{- include "common.dmaap.provisioning._volumes" . | nindent XX -}}
*/}}

{{- define "common.dmaap.provisioning._volumeMounts" -}}
{{- $dot := default . .dot -}}
- mountPath: /config-input
  name: app-config-input
- mountPath: /config
  name: app-config
{{- range $name, $volume := $dot.Values.volumes }}
- name: {{ $volume.name }}
  mountPath: {{ $volume.path }}
{{- end }}
{{- end -}}

{{- define "common.dmaap.provisioning._volumes" -}}
{{- $dot := default . .dot -}}
{{- range $name, $volume := $dot.Values.volumes }}
- name: {{ $volume.name }}
  configMap:
    defaultMode: 420
    name: {{ include "common.fullname" $dot }}-{{ printf "%s" $volume.name }}
{{- end }}
{{- end -}}

{{- define "common.dmaap.provisioning.initContainer" -}}
{{- $dot := default . .dot -}}
{{- $drNeedProvisioning := or $dot.Values.drFeedConfig $dot.Values.drSubConfig -}}
{{- if $drNeedProvisioning -}}
- name: {{ include "common.name" $dot }}-init-dmaap-provisioning
  image: {{ include "repositoryGenerator.image.drProvClient" $dot }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  env:
  - name: PROTO
    value: "http"
  - name: PORT
    value: "8080"
  - name: REQUESTID
    value: "{{ include "common.name" $dot }}-dmaap-provisioning"
  {{- range $cred := $dot.Values.credentials }}
  - name: {{ $cred.name }}
    {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" $cred.uid "key" $cred.key) | nindent 4 }}
  {{- end }}
  volumeMounts:
  {{- include "common.dmaap.provisioning._volumeMounts" $dot | trim | nindent 2 }}
  resources: {{ include "common.resources" $dot | nindent 4 }}
{{- end -}}
{{- end -}}