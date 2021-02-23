{{- define "so.certificate.container_importer" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{ include "common.certInitializer.initContainer" $subchartDot }}
{{- end -}}

{{- define "so.certificate.volumes" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{ include "common.certInitializer.volumes" $subchartDot }}
{{- end -}}

{{- define "so.certificate.volumeMount" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{ include "common.certInitializer.volumeMount" $subchartDot }}
{{- end -}}

{{- define "so.certificates.env" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{-   if $dot.Values.global.aafEnabled }}
- name: TRUSTSTORE
  value: {{ $subchartDot.Values.certInitializer.credsPath }}/{{ $subchartDot.Values.aaf.trustore }}
{{-     if $dot.Values.global.security.aaf.enabled }}
- name: KEYSTORE
  value: {{ $subchartDot.Values.certInitializer.credsPath }}/org.onap.so.p12
{{-     end }}
{{-   end }}
{{- end -}}
