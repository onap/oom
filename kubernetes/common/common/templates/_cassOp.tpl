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
    serverVersion: {{ .Values.k8ssandraOperator.cassandraVersion }} # Global
    storageConfig:
      cassandraDataVolumeClaimSpec:
        storageClassName: {{ .Values.k8ssandraOperator.persistence.storageClassName }} #  local-pathGlobal
        accessModes:
          - ReadWriteOnce # ReadWriteOnce
        resources:
          requests:
            storage: {{ .Values.k8ssandraOperator.persistence.size }} #Component 5Gi
    superuserSecretRef:
      name: {{ include "common.fullname" . }}-{{ .Values.k8ssandraOperator.config.secretName }}
    config:
      jvmOptions:
        heapSize: {{ .Values.k8ssandraOperator.config.jvmOptions.heapSize }}   #Component 512M
    networking:
      hostNetwork: {{ .Values.k8ssandraOperator.config.hostNetwork }} #true
    datacenters:
      {{- range $datacenter := .Values.k8ssandraOperator.datacenters }}
      - metadata:
          name: {{ $datacenter.name }}  #Component dc1
        size:  {{ $datacenter.size }} #Component 1
      {{- end }}
  #medusa:
  #  storageProperties:
      # Can be either of local, google_storage, azure_blobs, s3, s3_compatible, s3_rgw or ibm_storage 
  #    storageProvider: s3_compatible
      # Name of the secret containing the credentials file to access the backup storage backend
  #    storageSecretRef:
        name: medusa-bucket-key
      # Name of the storage bucket
  #    bucketName: dev-monitoring-bucket
      # Prefix for this cluster in the storage bucket directory structure, used for multitenancy
      # prefix: test
      # Host to connect to the storage backend (Omitted for GCS, S3, Azure and local).
  #    host: storage08-api.tnaplab.telekom.de
      # Port to connect to the storage backend (Omitted for GCS, S3, Azure and local).
      # port: 9000
      # Region of the storage bucket
      # region: us-east-1
      
      # Whether or not to use SSL to connect to the storage backend
  #    secure: true 
      
      # Maximum backup age that the purge process should observe.
      # 0 equals unlimited
      # maxBackupAge: 0

      # Maximum number of backups to keep (used by the purge process).
      # 0 equals unlimited
      # maxBackupCount: 0

      # AWS Profile to use for authentication.
      # apiProfile: 
      # transferMaxBandwidth: 50MB/s

      # Number of concurrent uploads.
      # Helps maximizing the speed of uploads but puts more pressure on the network.
      # Defaults to 1.
      # concurrentTransfers: 1
      
      # File size in bytes over which cloud specific cli tools are used for transfer.
      # Defaults to 100 MB.
      # multiPartUploadThreshold: 104857600
      
      # Age after which orphan sstables can be deleted from the storage backend.
      # Protects from race conditions between purge and ongoing backups.
      # Defaults to 10 days.
      # backupGracePeriodInDays: 10
      
      # Pod storage settings to use for local storage (testing only)
      # podStorage:
      #   storageClassName: standard
      #   accessModes:
      #     - ReadWriteOnce
      #   size: 100Mi


{{ end }}
