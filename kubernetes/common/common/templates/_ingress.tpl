{{- define "ingress.config.port" -}}
{{- if .Values.ingress -}}
{{- if or (not .Values.global.ingress.virtualhost) (not .Values.global.ingress.virtualhost.enabled) -}}
  - http:
      paths:
{{- range .Values.ingress.service }}
        - path: {{  printf "/%s" (required "baseaddr" .baseaddr) }}
          backend:
            serviceName: {{ .name }}
            servicePort: {{ .port }}
{{- end -}}
{{- else if .Values.ingress.service -}}
{{- $burl := (required "baseurl" .Values.global.ingress.virtualhost.baseurl) -}}
{{ range .Values.ingress.service }}
  - host: {{ printf "%s.%s" (required "baseaddr" .baseaddr) $burl }}
    http:
      paths:
      - backend:
          serviceName: {{ .name }}
          servicePort: {{ .port }}
{{- end -}}
{{- else -}}
        - path: {{ printf "/%s" .Chart.Name }}
          backend:
            serviceName: {{ .Chart.Name }}
            servicePort: {{ .Values.service.externalPort }}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "ingress.config.annotations.ssl" -}}
{{- if .Values.ingress.config -}}
{{- if .Values.ingress.config.ssl -}}
{{- if eq .Values.ingress.config.ssl "redirect" -}}
kubernetes.io/ingress.class: nginx
nginx.ingress.kubernetes.io/ssl-passthrough: "true"
nginx.ingress.kubernetes.io/ssl-redirect: "true"
{{-  else if eq .Values.ingress.config.ssl "native" -}}
nginx.ingress.kubernetes.io/ssl-redirect: "true"
{{-  else if eq .Values.ingress.config.ssl "none" -}}
nginx.ingress.kubernetes.io/ssl-redirect: "false"
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}


{{- define "ingress.config.annotations" -}}
{{- if .Values.ingress -}}
{{- if .Values.ingress.annotations -}}
{{ toYaml .Values.ingress.annotations | indent 4 | trim }}
{{- end -}}
{{- end -}}
{{ include "ingress.config.annotations.ssl" . | indent 4 | trim }}
{{- end -}}


{{- define "common.ingress" -}}
{{- if .Values.ingress -}}
{{- if .Values.global.ingress -}}
{{- if and .Values.ingress.enabled .Values.global.ingress.enabled -}}
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
  {{ include "ingress.config.port" . | trim }}
{{- if .Values.ingress.tls }}
  tls:
{{ toYaml .Values.ingress.tls | indent 4 }}
  {{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}
{{- end -}}