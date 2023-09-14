{{ if .Values.mariadbConfiguration }} 
apiVersion: mariadb.mmontes.io/v1alpha1
kind: MariaDB
metadata:
  name: {{ .Values.nameOverride }}
spec:
  podSecurityContext:
    runAsUser: {{ .Values.securityContext.user_id }}
    runAsGroup: {{ .Values.securityContext.group_id }}
    fsGroup: 10001
  inheritMetadata:
    annotations:
      traffic.sidecar.istio.io/excludeInboundPorts: {{ .Values.podAnnotations.traffic.sidecar.istio.io/excludeInboundPorts }}
      traffic.sidecar.istio.io/excludeOutboundPorts: {{ .Values.podAnnotations.traffic.sidecar.istio.io/excludeOutboundPorts }}
      traffic.sidecar.istio.io/includeInboundPorts: {{ .Values.podAnnotations.traffic.sidecar.istio.io/includeInboundPorts }}
    labels:
      app: mariadb-galera
      version: 11.0.2
  rootPasswordSecretKeyRef:
    name: {{ .Values.mariadbOperator.rootname }}
    key: {{ .Values.mariadbOperator.rootkey }}
  database: {{ .Values.mariadbOperator.database }}
  username: {{ .Values.mariadbOperator.username }}
  image: 
    repository: {{ include "repositoryGenerator.mariadbImage" . }} 
    tag: "10.11.3"
    pullPolicy: {{ .Values.pullPolicy }}  
  port: 3306 
  replicas: {{ .Values.replicaCount }}
  livenessProbe:
    initialDelaySeconds: {{ .Values.livenessProbe.initialDelaySeconds }}
    periodSeconds: {{ .Values.livenessProbe.periodSeconds }}
    timeoutSeconds: {{ .Values.livenessProbe.timeoutSeconds }}
  readinessProbe:
    initialDelaySeconds: {{ .Values.readinessProbe.initialDelaySeconds }}
    periodSeconds: {{ .Values.readinessProbe.periodSeconds }}
    timeoutSeconds: {{ .Values.readinessProbe.timeoutSeconds }}
  galera:
    enabled: true
    sst: mariabackup
    replicaThreads: 1
    agent:
      image:
        repository: {{ include "repositoryGenerator.githubContainerRegistry" . }}/{{ .Values.mariadbOperator.galera.imageOpAgent }}
        tag: "v0.0.2"
        pullPolicy: IfNotPresent
      port: 5555
      kubernetesAuth:
        enabled: true
        authDelegatorRoleName: mariadb-galera-auth
      gracefulShutdownTimeout: 5s
    recovery:
      enabled: true
      clusterHealthyTimeout: 1m
      clusterBootstrapTimeout: 5m
      podRecoveryTimeout: 3m
      podSyncTimeout: 3m
    initContainer:
      image:
        repository: {{ include "repositoryGenerator.githubContainerRegistry" . }}/{{ .Values.mariadbOperator.galera.imageOpInit }}
        tag: "v0.0.3"
        pullPolicy: IfNotPresent
    volumeClaimTemplate:
	  resources:
        requests:
          storage: {{ .Values.persistence.size }}
      accessModes:
        - ReadWriteOnce
  affinity:
    podAntiAffinity:
      requiredDuringSchedulingIgnoredDuringExecution:
        - topologyKey: "kubernetes.io/hostname"
  tolerations:
    - key: "mariadb.mmontes.io/ha"
      operator: "Exists"
      effect: "NoSchedule"
  podDisruptionBudget: 
    maxUnavailable: 66%
  updateStrategy: 
    type: {{ .Values.updateStrategy.type }}
  myCnf: | 
    {{ .Values.mariadbConfiguration | indent 4 }}
  resources:
    requests:
      cpu: {{ .Values.resources.requests.cpu }}
      memory: {{ .Values.resources.requests.memory }}
    limits:
      memory: {{ .Values.resources.limits.memory }}
  volumeClaimTemplate:
   resources:
    requests:
     storage:
	  {{ .Values.mariadbOperator.volumeClaimTemplate.storage }}
    accessModes:
      - ReadWriteOnce
  service: 
    type: ClusterIP
{{- end }}
