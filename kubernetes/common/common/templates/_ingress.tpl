{{- define "ingress.config.port" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.service -}}
  - http:
      paths:
{{- range .Values.ingress.service }}
        - path: {{ .path }}
          backend:
            serviceName: {{ .name }}
            servicePort: {{ .port }}
{{- end -}}
{{- else if .Values.ingress.vhosts -}}
{{- range .Values.ingress.vhosts -}}
  - host: {{ .vhost }}
    http:
      paths:
{{- range .service }}
      - backend:
          serviceName: {{ .name }}
          servicePort: {{ .port }}
{{- end -}}
{{- end -}}
{{- else -}}
        - path: {{ printf "/%s" .Chart.Name }}
          backend:
            serviceName: {{ .Chart.Name }}
            servicePort: {{ .Values.service.externalPort }}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "ingress.config.annotations" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.annotations -}}
{{ toYaml .Values.ingress.annotations | indent 4 | trim }}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "common.ingress" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.enabled -}}
apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: {{ include "common.fullname" . }}-ingress
  annotations:
    {{ include "ingress.config.annotations" . }}
  labels:
    app: {{ .Chart.Name }}
    chart: {{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}
    release: {{ .Release.Name }}
    heritage: {{ .Release.Service }}
spec:
  rules:
  {{ include "ingress.config.port" . }}
{{- if .Values.ingress.tls }}
  tls:
{{ toYaml .Values.ingress.tls | indent 4 }}
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}

