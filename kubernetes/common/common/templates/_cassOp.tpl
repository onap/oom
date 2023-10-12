{{/*
# Copyright © 2022 Deutsche Telekom AG
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

{{/* Cassandra Data Center. */}}
{{- define "common.k8ssandraCluster" -}}
{{- $global := .Values.global }}
---
apiVersion: k8ssandra.io/v1alpha1
kind: K8ssandraCluster
metadata:
  name: {{ .Values.k8ssandraOperator.config.clusterName }}
spec:
  reaper:
    containerImage:
      registry: {{ include "repositoryGenerator.dockerHubRepository" . }}
    autoScheduling:
      enabled: true
    metadata:
      commonLabels:
        app: {{ .Values.k8ssandraOperator.config.clusterName }}-reaper
        version: {{ .Values.k8ssandraOperator.cassandraVersion }}
  stargate:
    containerImage:
      registry: {{ include "repositoryGenerator.dockerHubRepository" . }}
      tag: {{ .Values.k8ssandraOperator.stargate.tag }}
    size: {{ .Values.k8ssandraOperator.stargate.size }}
    heapSize: {{ .Values.k8ssandraOperator.stargate.jvmOptions.heapSize }}
    metadata:
      commonLabels:
        app: {{ .Values.k8ssandraOperator.config.clusterName }}-stargate
        version: {{ .Values.k8ssandraOperator.cassandraVersion }}
    livenessProbe:
      initialDelaySeconds: 200
      periodSeconds: 10
      failureThreshold: 20
      successThreshold: 1
      timeoutSeconds: 20
    readinessProbe:
      initialDelaySeconds: 200
      periodSeconds: 10
      failureThreshold: 20
      successThreshold: 1
      timeoutSeconds: 20
  cassandra:
    serverVersion: {{ .Values.k8ssandraOperator.cassandraVersion }}
    storageConfig:
      cassandraDataVolumeClaimSpec:
        {{ if .Values.k8ssandraOperator.persistence.storageClassName -}}
        storageClassName: {{ .Values.k8ssandraOperator.persistence.storageClassName }}
        {{- end }}
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.k8ssandraOperator.persistence.size }}
    superuserSecretRef:
      name: {{ include "common.fullname" . }}-{{ .Values.k8ssandraOperator.config.secretName }}
    config:
      {{ if .Values.k8ssandraOperator.config.casOptions -}}
      cassandraYaml:
        {{ toYaml .Values.k8ssandraOperator.config.casOptions | nindent 8 }}
      {{- end }}
      {{ if .Values.k8ssandraOperator.config.jvmOptions -}}
      jvmOptions:
        {{ toYaml .Values.k8ssandraOperator.config.jvmOptions | nindent 8 }}
      {{- end }}
    networking:
      hostNetwork: {{ .Values.k8ssandraOperator.config.hostNetwork }}
    datacenters:
      {{- range $datacenter := .Values.k8ssandraOperator.datacenters }}
      - metadata:
          name: {{ $datacenter.name }}
        size: {{ $datacenter.size }}
      {{- end }}
    {{ if .Values.podAnnotations -}}
    metadata:
      pods:
        annotations:
          {{ toYaml .Values.podAnnotations | nindent 10 }}
      commonLabels:
        app: {{ .Values.k8ssandraOperator.config.clusterName }}
        version: {{ .Values.k8ssandraOperator.cassandraVersion }}
    {{- end }}
{{ end }}
