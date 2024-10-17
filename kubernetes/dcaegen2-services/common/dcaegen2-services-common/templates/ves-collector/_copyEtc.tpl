{{- define "dcaegen2-ves-collector.vesCollectorCopyEtc" -}}
- name: dcae-ves-collector-copy-etc
  command: ["cp", "-R", "/opt/app/VESCollector/etc/.", "/opt/app/VESCollector/etc_rw/"]
  image: {{ default ( include "repositoryGenerator.repository" . ) .Values.imageRepositoryOverride }}/{{ .Values.image }}
  imagePullPolicy: Always
  resources:
    limits:
      cpu: {{ .Values.copyEtc.resources.limits.cpu }}
      memory: {{ .Values.copyEtc.resources.limits.memory }}
    requests:
      cpu: {{ .Values.copyEtc.resources.requests.cpu }}
      memory: {{ .Values.copyEtc.resources.requests.memory }}
  securityContext:
    allowPrivilegeEscalation: false
    capabilities:
      drop:
        - ALL
        - CAP_NET_RAW
    readOnlyRootFilesystem: true
    runAsNonRoot: true
  terminationMessagePath: /dev/termination-log
  terminationMessagePolicy: File
  volumeMounts:
    - mountPath: /opt/app/VESCollector/etc_rw
      name: ves-collector-etc
{{- end }}
