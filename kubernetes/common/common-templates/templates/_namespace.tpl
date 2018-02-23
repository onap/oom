{{/*
  Resolve the namespace to apply to a chart. The default namespace suffix
  is the name of the chart. This can be overridden if necessary (eg. for subcharts)
  using the following value:

  - .Values.nsPrefix  : override namespace prefix
  - .Values.nsSuffix  : override namespace suffix
*/}}
{{- define "common.namespace" -}}
  {{- $prefix := default .Release.Name .Values.nsPrefix -}}
  {{- $suffix := default .Chart.Name .Values.nsSuffix -}}
  {{- printf "%s-%s" $prefix $suffix -}}
{{- end -}}
