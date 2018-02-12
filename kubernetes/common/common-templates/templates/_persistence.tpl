{{/*
  Resolve the persistence.mountPath to apply to a chart.

  - .Values.persistence.mountPath         : default mount path value
  - .Values.global.persistence.mountPath  : overrides mount path for all charts
*/}}
{{- define "common.mountpath" -}}
  {{ if .Values.global.persistence }}
    {{- default .Values.persistence.mountPath .Values.global.persistence.mountPath -}}
  {{- else -}}
    {{- default "/" .Values.persistence.mountPath -}}
  {{- end -}}
{{- end -}}
