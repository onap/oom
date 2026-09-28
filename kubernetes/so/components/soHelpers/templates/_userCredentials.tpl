{{- define "so.helpers.userCredentials" -}}
{{- range .Values.global.auth.so.users }}
- username: {{ .username }}
  password: {{ .password | quote }}
{{- end }}
{{- end -}}
