{{- define "wfd-be.internalPort" }}{{ if .Values.config.serverSSLEnabled }}{{ .Values.service.internalPort2 }}{{ else }}{{ .Values.service.internalPort }}{{ end }}{{- end }}
