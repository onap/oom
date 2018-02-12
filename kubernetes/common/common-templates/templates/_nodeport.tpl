{{/*
  Resolve the node port prefix to apply to nodeport values.

  - .Values.nodePortPrefix          : default node port prefix
  - .Values.global.nodePortPrefix   : overrides node port prefix for all charts
*/}}
{{- define "common.nodeport.prefix" -}}
  {{ if .Values.global.nodePortPrefix }}
    {{- default .Values.nodePortPrefix .Values.global.nodePortPrefix -}}
  {{- else -}}
    {{- default 302 .Values.nodePortPrefix -}}
  {{- end -}}
{{- end -}}