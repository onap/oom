{{- define "so.helpers.profileProperty" -}}
  {{ if .condition }}{{ .value1 }}{{ else }}{{ .value2 }}{{ end }}
{{- end -}}
