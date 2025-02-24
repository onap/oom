{{- define "so.helpers.startupProbe" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
startupProbe:
  httpGet:
    path: {{ $subchartDot.Values.startupProbe.path }}
    port: {{ $subchartDot.Values.containerPort }}
    scheme: {{  $subchartDot.Values.startupProbe.scheme }}
  periodSeconds: {{ $subchartDot.Values.startupProbe.periodSeconds }}
  timeoutSeconds: {{ $subchartDot.Values.startupProbe.timeoutSeconds }}
  successThreshold: {{ $subchartDot.Values.startupProbe.successThreshold }}
  failureThreshold: {{ $subchartDot.Values.startupProbe.failureThreshold }}
{{- end -}}
