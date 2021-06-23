{{- define "wfd-be.internalPort" }}{{ if (include "common.needTLS" .) }}{{ .Values.service.internalPort2 }}{{ else }}{{ .Values.service.internalPort }}{{ end }}{{- end }}
