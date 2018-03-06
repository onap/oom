{{/*
  Expand the name of a chart.
*/}}
{{- define "common.name" -}}
  {{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
  Create a default fully qualified application name.
  Truncated at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "common.fullname" -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- $suffix := default .Chart.Name .Values.nsSuffix -}}
  {{- printf "%s-%s" $suffix $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
