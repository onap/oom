{{/*
  Resolve the primary container image for a chart.

  - .Values.image               : name and tag of image
  - .Values.repository          : image repository
  - .Values.global.repository   : overrides image repository for all charts
*/}}
{{- define "common.image" -}}
  {{- if .Values.global.repository -}}
    {{- printf "%s/%s" .Values.global.repository .Values.image | quote -}}
  {{- else -}}
    {{- printf "%s/%s" .Values.repository .Values.image | quote -}}
  {{- end -}}
{{- end -}}



{{/*
  Resolve the readinesscheck image for a chart.

  - .Values.global.readinesscheck.image       : overrides default name and tag of readinesscheck image
  - .Values.global.readinesscheck.repository  : overrides default readinesscheck image repository
*/}}
{{- define "common.image.readiness" -}}
  {{ if .Values.global.readiness }}
    {{- $repo := default "oomk8s" .Values.global.readiness.repository -}}
    {{- $image := default "readiness-check:1.0.0" .Values.global.readiness.image -}}
    {{- printf "%s/%s" $repo $image | quote -}}
  {{- else -}}
    {{- printf "%s/%s" "oomk8s" "readiness-check:1.0.0" | quote -}}
  {{- end -}}
{{- end -}}

 
{{/*
  Resolve the log agent image for a chart.

  - .Values.global.logging.image       : overrides default name and tag of log agent image
  - .Values.global.logging.repository  : overrides default log agent image repository
*/}}
{{- define "common.image.logging" -}}
  {{ if .Values.global.logging }}
    {{- $repo := default "docker.elastic.co" .Values.global.logging.repository -}}
    {{- $image := default "beats/filebeat:5.5.0" .Values.global.logging.image -}}
    {{- printf "%s/%s" $repo $image | quote -}}
  {{- else -}}
    {{- printf "%s/%s" "docker.elastic.co" "beats/filebeat:5.5.0" | quote -}}
  {{- end -}}
{{- end -}}
