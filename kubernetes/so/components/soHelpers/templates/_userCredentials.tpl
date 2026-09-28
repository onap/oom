{{- define "so.helpers.userCredentials" -}}
{{- $users := list -}}
{{- range .Values.global.auth.so.users -}}
{{- $users = append $users (dict "username" .username "password" .password) -}}
{{- end -}}
{{- toJson $users -}}
{{- end -}}
