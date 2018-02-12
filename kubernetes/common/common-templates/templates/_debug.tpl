{{/*
  Resolve the persistence.mountPath to apply to a chart.
  
  - .Values.persistence.mountPath         : default mount path value
  - .Values.global.persistence.mountPath  : overrides mount path for all charts

*/}}
{{- define "common.debug.enabled" -}}
  {{ if .Values.global.debugEnabled }}
    {{- .Values.global.debugEnabled -}}
  {{- else -}}
    {{- default false .Values.debugEnabled -}}
  {{- end -}}
{{- end -}}
