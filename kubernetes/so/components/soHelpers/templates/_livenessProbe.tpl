{{- define "so.helpers.livenessProbe" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
livenessProbe:
  httpGet:
    path: {{ $subchartDot.Values.livenessProbe.path }}
    port: {{ $subchartDot.Values.containerPort }}
    scheme: {{  $subchartDot.Values.livenessProbe.scheme }}
    {{- if $subchartDot.Values.global.security.aaf.enabled }}
    httpHeaders:
    - name: Authorization
      value: {{ $subchartDot.Values.global.aaf.auth.header }}
    {{- end }}
  initialDelaySeconds: {{ $subchartDot.Values.livenessProbe.initialDelaySeconds }}
  periodSeconds: {{ $subchartDot.Values.livenessProbe.periodSeconds }}
  timeoutSeconds: {{ $subchartDot.Values.livenessProbe.timeoutSeconds }}
  successThreshold: {{ $subchartDot.Values.livenessProbe.successThreshold }}
  failureThreshold: {{ $subchartDot.Values.livenessProbe.failureThreshold }}
{{- end -}}
