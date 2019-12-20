{{- define "helpers.livenessProbe" -}} 
livenessProbe:
  httpGet:
    path: {{- index .Values.livenessProbe.path|indent 2}}
    port: {{ index .Values.containerPort }}
    scheme: {{- index .Values.livenessProbe.scheme| indent 2}}
    {{- if eq .Values.global.security.aaf.enabled true }}
    httpHeaders:
    - name: Authorization
      value: {{ index .Values.global.aaf.auth.header }}
    {{- end }}
  initialDelaySeconds: {{ index .Values.livenessProbe.initialDelaySeconds}}
  periodSeconds: {{ index .Values.livenessProbe.periodSeconds}}
  timeoutSeconds: {{ index .Values.livenessProbe.timeoutSeconds}}
  successThreshold: {{ index .Values.livenessProbe.successThreshold}}
  failureThreshold: {{ index .Values.livenessProbe.failureThreshold}}
{{- end -}}
