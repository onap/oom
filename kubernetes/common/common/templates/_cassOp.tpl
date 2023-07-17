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
    heapSize: 512Mi
    autoScheduling:
      enabled: true
  stargate:
    containerImage:
      registry: {{ include "repositoryGenerator.dockerHubRepository" . }}
      tag: {{ .Values.k8ssandraOperator.stargate.tag }}
    size: {{ .Values.k8ssandraOperator.stargate.size }}
    heapSize: {{ .Values.k8ssandraOperator.stargate.jvmOptions.heapSize }}
  cassandra:
    serverVersion: {{ .Values.k8ssandraOperator.cassandraVersion }}
    storageConfig:
      cassandraDataVolumeClaimSpec:
        {{ if .Values.k8ssandraOperator.persistence.storageClassName -}}
        storageClassName: {{ .Values.k8ssandraOperator.persistence.storageClassName }}
        accessModes:
          - ReadWriteOnce
        {{- end }}
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
{{ end }}
