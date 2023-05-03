{{/* Cassandra Data Center. */}}
{{- define "common.k8ssandraCluster" -}}
{{- $global := .Values.global }}
---
apiVersion: k8ssandra.io/v1alpha1
kind: K8ssandraCluster
metadata:
  name: {{ .Values.config.clusterName }}
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
    size: {{ .Values.k8ssandraOperator.stargate.size }}
    heapSize: {{ .Values.k8ssandraOperator.stargate.jvmOptions.heapSize }}
  cassandra:
    serverVersion: {{ .Values.k8ssandraOperator.cassandraVersion }}
    storageConfig:
      cassandraDataVolumeClaimSpec:
        storageClassName: {{ .Values.k8ssandraOperator.persistence.storageClassName }}
        accessModes:
          - ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.k8ssandraOperator.persistence.size }}
    superuserSecretRef:
      name: {{ include "common.fullname" . }}-{{ .Values.k8ssandraOperator.config.secretName }}
    config:
      jvmOptions:
        heapSize: {{ .Values.k8ssandraOperator.config.jvmOptions.heapSize }}
    networking:
      hostNetwork: {{ .Values.k8ssandraOperator.config.hostNetwork }}
    datacenters:
      {{- range $datacenter := .Values.k8ssandraOperator.datacenters }}
      - metadata:
          name: {{ $datacenter.name }}
        size: {{ $datacenter.size }}
      {{- end }}
{{ end }}
