{{/*
################################################################################
#   Copyright (C) 2021 Nordix Foundation.                                      #
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
  DMaaP topics (on Message Router) and feeds (on Data Router), with associated authorization (on AAF).
  DMaap Bus Controller endpoints are used to provision:
  - Authorized topic on MR, and to create and grant permission for publishers and subscribers.
  - Feed on DR, with associated user authentication.

  common.dmaap.provisioning.initContainer:
  This template make use of Dmaap Bus Controller docker image to create resources on Dmaap Data Router
  microservice, with the help of dbc-client.sh script it makes use of Bus Controller API to create Feed, Topics.
  If the resource creation is successful via script response is logged back at particular location with
  appropriate naming convention.

  More details can be found at :
  (https://wiki.onap.org/pages/viewpage.action?pageId=103417564)

  The template directly references data in .Values, and indirectly (through its
  use of templates from the ONAP "common" collection) references data in .Release.

  Parameter for _dmaapProvisioning to be defined in values.yaml
  # DataRouter Feed Configuration
  drFeedConfig:
    - feedName: bulk_pm_feed
      owner: dcaecm
      feedVersion: 0.0
      asprClassification: unclassified
      feedDescription: DFC Feed Creation

  # DataRouter Publisher Configuration
  drPubConfig:
    - feedName: bulk_pm_feed
      dcaeLocationName: loc00

  # DataRouter Subscriber Configuration
  drSubConfig:
    - feedName: bulk_pm_feed
      decompress: True
      dcaeLocationName: loc00
      privilegedSubscriber: True
      deliveryURL: https://dcae-pm-mapper:8443/delivery

  # MessageRouter Topic, Publisher Configuration
  mrTopicsConfig:
    - topicName: PERFORMANCE_MEASUREMENTS
      topicDescription: Description about Topic
      owner: dcaecm
      tnxEnabled: false
      clients:
        - dcaeLocationName: san-francisco
          clientRole: org.onap.dcae.pmPublisher
          action:
            - pub
            - view

  # ConfigMap Configuration for DR Feed, Dr_Publisher, Dr_Subscriber, MR Topics
  volumes:
    - name: feeds-config
      path: /opt/app/config/feeds
    - name: drpub-config
      path: /opt/app/config/dr_pubs
    - name: drsub-config
      path: /opt/app/config/dr_subs
    - name: topics-config
      path: /opt/app/config/topics

  In deployments/jobs/stateful include:
  initContainers:
  {{- include "common.dmaap.provisioning.initContainer" . | nindent XX }}
  volumes:
  {{- include "common.dmaap.provisioning._volumes" . | nindent XX -}}
*/}}

{{- define "common.dmaap.provisioning._volumeMounts" -}}
{{- $dot := default . .dot -}}
- mountPath: /opt/app/config/cache
  name: dbc-response-cache
{{- range $name, $volume := $dot.Values.volumes }}
- name: {{ $volume.name }}
  mountPath: {{ $volume.path }}
{{- end }}
{{- end -}}

{{- define "common.dmaap.provisioning._volumes" -}}
{{- $dot := default . .dot -}}
- name: dbc-response-cache
  emptyDir: {}
{{- range $name, $volume := $dot.Values.volumes }}
- name: {{ $volume.name }}
  configMap:
    defaultMode: 420
    name: {{ include "common.fullname" $dot }}-{{ printf "%s" $volume.name }}
{{- end }}
{{- end -}}

{{- define "common.dmaap.provisioning.initContainer" -}}
{{- $dot := default . .dot -}}
{{- $drFeedConfig := default $dot.Values.drFeedConfig .drFeedConfig -}}
{{- $mrTopicsConfig := default $dot.Values.mrTopicsConfig .mrTopicsConfig -}}
{{- if or $drFeedConfig $mrTopicsConfig -}}
- name: {{ include "common.name" $dot }}-init-dmaap-provisioning
  image: {{ include "repositoryGenerator.image.dbcClient" $dot }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  env:
  - name: RESP_CACHE
    value: /opt/app/config/cache
  - name: REQUESTID
    value: "{{ include "common.name" $dot }}-dmaap-provisioning"
  {{- range $cred := $dot.Values.credentials }}
  - name: {{ $cred.name }}
    {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" $cred.uid "key" $cred.key) | nindent 4 }}
  {{- end }}
  volumeMounts:
  {{- include "common.dmaap.provisioning._volumeMounts" $dot | trim | nindent 2 }}
  resources: {{ include "common.resources" $dot | nindent 1 }}
- name: {{ include "common.name" $dot }}-init-merge-config
  image: {{ include "repositoryGenerator.image.envsubst" $dot }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  command:
  - /bin/sh
  args:
  - -c
  - |
    set -uex -o pipefail
    if [ -d /opt/app/config/cache ]; then
      cd /opt/app/config/cache
      for file in $(ls feed*); do
        NUM=$(echo "$file" | sed 's/feedConfig-\([0-9]\+\)-resp.json/\1/')
        export DR_LOG_URL_"$NUM"="$(grep -o '"logURL":"[^"]*' "$file" | grep -w "feedlog" | cut -d '"' -f4)"
        export DR_FILES_PUBLISHER_URL_"$NUM"="$(grep -o '"publishURL":"[^"]*' "$file" | cut -d '"' -f4)"
      done
      for file in $(ls drpub*); do
        NUM=$(echo "$file" | sed 's/drpubConfig-\([0-9]\+\)-resp.json/\1/')
        export DR_FILES_PUBLISHER_ID_"$NUM"="$(grep -o '"pubId":"[^"]*' "$file" | cut -d '"' -f4)"
      done
      for file in $(ls drsub*); do
        NUM=$(echo "$file" | sed 's/drsubConfig-\([0-9]\+\)-resp.json/\1/')
        export DR_FILES_SUBSCRIBER_ID_"$NUM"="$(grep -o '"subId":"[^"]*' "$file" | cut -d '"' -f4)"
      done
      for file in $(ls topics*); do
        NUM=$(echo "$file" | sed 's/topicsConfig-\([0-9]\+\)-resp.json/\1/')
        export MR_FILES_PUBLISHER_CLIENT_ID_"$NUM"="$(grep -o '"mrClientId":"[^"]*' "$file" | cut -d '"' -f4)"
      done
    else
      echo "No Response logged for Dmaap BusController Http POST Request..!"
    fi
    cd /config-input && for PFILE in `ls -1`; do envsubst <${PFILE} >/config/${PFILE}; done
  env:
  {{- range $cred := $dot.Values.credentials }}
  - name: {{ $cred.name }}
    {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" $cred.uid "key" $cred.key) | nindent 4 }}
  {{- end }}
  volumeMounts:
  - mountPath: /opt/app/config/cache
    name: dbc-response-cache
  - mountPath: /config-input
    name: app-config-input
  - mountPath: /config
    name: app-config
  resources:
    limits:
      cpu: 200m
      memory: 250Mi
    requests:
      cpu: 100m
      memory: 200Mi
{{- end -}}
{{- end -}}