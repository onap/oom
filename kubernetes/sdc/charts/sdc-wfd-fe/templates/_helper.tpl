{{- define "wfd-fe.internalPort" }}{{ if .Values.config.isHttpsEnabled }}{{ .Values.service.internalPort2 }}{{ else }}{{ .Values.service.internalPort }}{{ end }}{{- end }}
