{{/* Cassandra Data Center. */}}
{{- define "common.dc" -}}
{{- $global := .Values.global }}
apiVersion: k8ssandra.io/v1alpha1
kind: K8ssandraCluster
metadata:
  name: {{ include "common.name" . }}-co
spec:
  cassandra:
    serverVersion: {{ $global.K8SCluster.cassandra.serverVersion }} # Global
    storageConfig:
      cassandraDataVolumeClaimSpec:
        storageClassName: {{ $global.K8SCluster.storageConfig.storageClassName }} #  local-pathGlobal
        accessModes:
          - ReadWriteOnce # ReadWriteOnce
        resources:
          requests:
            storage: {{ $global.K8SCluster.storageConfig.resourcesStorage }} # Component 5Gi
    #superuserSecretRef:
    config:
      jvmOptions:
        heapSize: {{ .Values.K8SCluster.jvmOptions.heapSize }}   # Component 512M
    networking:
      hostNetwork: {{ .Values.K8SCluster.networking.hostNetwork }} # true
    datacenters:
      - metadata:
           name: {{ .Values.K8SCluster.datacenters.metadata.name }}  #Component dc1
        size:  {{ .Values.K8SCluster.datacenters.metadata.size }} #Component 1
        stargate:
          size: {{ .Values.K8SCluster.datacenters.stargate.size }} #Component 1
          heapSize:
           {{ .Values.K8SCluster.datacenters.stargate.heapSize }} #Component 1
{{ end }} 
