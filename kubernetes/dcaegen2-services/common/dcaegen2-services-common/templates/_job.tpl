{{/*
#============LICENSE_START========================================================
# ================================================================================
# Copyright (c) 2021 J. F. Lucas. All rights reserved.
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
dcaegen2-services-common.consulDeleteJob:
This template generates a Kubernetes Job that runs when a
DCAE microservice is deleted.  The Job deletes the Consul
entry that contains the microservice's configuration.

The template expects the full chart context as input.  A chart for a
DCAE microservice references this template using:
{{ include "dcaegen2-services-common.consulDeleteJob" . }}
The template directly references data in .Values, and indirectly (through its
use of templates from the ONAP "common" collection) references data in
.Release.

The microservice configuration data is loaded into Consul by an
initContainer that is part of the Kubernetes Deployment for the microservice.
See the documentation for dcaegen2-services-common.microserviceDeployment
for more information.
*/}}
{{- define "dcaegen2-services-common.consulDeleteJob" -}}
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ include "common.fullname" . }}-delete-config
  namespace: {{ include "common.namespace" . }}
  labels: {{ include "common.labels" . | nindent 4 }}
  annotations:
    "helm.sh/hook": pre-delete
    "helm.sh/hook-delete-policy": hook-succeeded,hook-failed
spec:
  template:
    metadata:
      name: {{ include "common.fullname" . }}-delete-config
      labels: {{ include "common.labels" . | nindent 8 }}
    spec:
      restartPolicy: Never
      containers:
      - name: dcae-config-delete
        image: {{ include "repositoryGenerator.repository" . }}/{{ .Values.global.consulLoaderImage }}
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
        args:
        - --delete-key
        - {{ include "common.name" . }}
{{ end -}}
