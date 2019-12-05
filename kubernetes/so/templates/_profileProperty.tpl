{{- define "helpers.profileProperty" -}}
  {{ if eq .condition true }}{{.value1}}{{else}}{{.value2}} {{ end }}
{{- end -}}
