{{/*
# Copyright © 2021 Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}
{{/*
  Resolve the name of a chart's serviceMonitor.

  The default will be the chart name (or $dot.Values.nameOverride if set).
  And the use of .Values.metrics.serviceMonitor.name overrides all.

  - .Values.metrics.serviceMonitor.name: override default serviceMonitor (ie. chart) name
  Example values file addition:
  metrics:
    serviceMonitor:
      enabled: true
      port: blueprints-processor-http
      ## specify target port if name is not given to the port in the service definition
      ##
      # targetPort: 8080
      path: /metrics
      basicAuth:
        enabled: false
        externalSecretName: mysecretname
        externalSecretUserKey: login
        externalSecretPasswordKey: password

      ## Namespace in which Prometheus is running
      ##
      # namespace: monitoring

      ## Interval at which metrics should be scraped.
      ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
      ##
      # interval: 60s

      ## Timeout after which the scrape is ended
      ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#endpoint
      ##
      # scrapeTimeout: 10s

      ## ServiceMonitor selector labels
      ## ref: https://github.com/bitnami/charts/tree/master/bitnami/prometheus-operator#prometheus-configuration
      ##
      selector:
        app: '{{ include "common.name" . }}'
        chart: '{{ .Chart.Name }}-{{ .Chart.Version | replace "+" "_" }}'
        release: '{{ include "common.release" . }}'
        heritage: '{{ .Release.Service }}'

      ## RelabelConfigs to apply to samples before scraping
      ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
      ## Value is evalued as a template
      ##
      relabelings: []

      ## MetricRelabelConfigs to apply to samples before ingestion
      ## ref: https://github.com/coreos/prometheus-operator/blob/master/Documentation/api.md#relabelconfig
      ## Value is evalued as a template
      ##
      metricRelabelings: []
      #  - sourceLabels:
      #      - "__name__"
      #    targetLabel: "__name__"
      #    action: replace
      #    regex: '(.*)'
      #    replacement: 'example_prefix_$1'

*/}}
{{/*
  Expand the serviceMonitor name for a chart.
*/}}
{{- define "common.serviceMonitorName" -}}
  {{- $name := default .Chart.Name .Values.nameOverride -}}
  {{- default $name .Values.metrics.serviceMonitor.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/* Define the metadata of serviceMonitor
     The function takes from one to four arguments (inside a dictionary):
     - .dot : environment (.)
     - .suffix : a string which will be added at the end of the name (with a '-').
     - .annotations: the annotations to add
     - .labels : labels to add
     Usage example:
      {{ include "common.serviceMonitorMetadata" ( dict "suffix" "myService" "dot" .) }}
      {{ include "common.serviceMonitorMetadata" ( dict "annotations" .Values.metrics.serviceMonitor.annotation "dot" .) }}
*/}}

{{- define "common.serviceMonitorMetadata" -}}
{{-   $dot := default . .dot -}}
{{-   $annotations := default "" .annotations -}}
{{-   $labels := default (dict) .labels -}}
{{- if $annotations -}}
annotations:
{{    include "common.tplValue" (dict "value" $annotations "context" $dot) | indent 2 }}
{{- end }}
name: {{ include "common.serviceMonitorName" $dot }}
{{- if $dot.Values.metrics.serviceMonitor.namespace }}
namespace: {{ $dot.Values.metrics.serviceMonitor.namespace }}
{{- else }}
namespace: {{ include "common.namespace" $dot }}
{{- end }}
{{- if $dot.Values.metrics.serviceMonitor.labels }}
labels: {{- include "common.tplValue" ( dict "value" $dot.Values.metrics.serviceMonitor.labels "context" $dot) | nindent 2 }}
{{- else }}
labels: {{- include "common.labels" (dict "labels" $labels "dot" $dot) | nindent 2 }}
{{- end -}}
{{- end -}}

{{/*
    Create service monitor template
*/}}
{{- define "common.serviceMonitor" -}}
{{-   $dot := default . .dot -}}
{{-   $labels := default (dict) .labels -}}
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
{{- include "common.serviceMonitorMetadata" $dot | nindent 2 }}
spec:
  endpoints:
  - path: {{ default "/metrics" $dot.Values.metrics.serviceMonitor.path }}
    {{- if $dot.Values.metrics.serviceMonitor.port }}
    port: {{ $dot.Values.metrics.serviceMonitor.port }}
    {{- else if $dot.Values.metrics.serviceMonitor.targetPort }}
    targetPort: {{ $dot.Values.metrics.serviceMonitor.targetPort }}
    {{- else }}
    port: tcp-metrics
    {{- end }}
    {{- if $dot.Values.metrics.serviceMonitor.isHttps }}
    scheme: https
    {{- if $dot.Values.metrics.serviceMonitor.tlsConfig }}
    tlsConfig: {{- include "common.tplValue" ( dict "value" $dot.Values.metrics.serviceMonitor.tlsConfig "context" $dot) | nindent 6 }}
    {{- else }}
    tlsConfig:
      insecureSkipVerify: true
    {{- end }}
    {{- end }}
    {{- if $dot.Values.metrics.serviceMonitor.basicAuth.enabled }}
    basicAuth:
      username:
        key: {{ $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretUserKey }}
        {{- if $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretNameSuffix }}
        name: {{ include "common.release" . }}-{{ $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretNameSuffix }}
        {{- else }}
        name: {{ $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretName }}
        {{- end }}
      password:
        key: {{ $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretPasswordKey }}
        {{- if $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretNameSuffix }}
        name: {{ include "common.release" . }}-{{ $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretNameSuffix }}
        {{- else }}
        name: {{ $dot.Values.metrics.serviceMonitor.basicAuth.externalSecretName }}
        {{- end }}
    {{- end }}
    {{- if $dot.Values.metrics.serviceMonitor.interval }}
    interval: {{ $dot.Values.metrics.serviceMonitor.interval }}
    {{- end }}
    {{- if $dot.Values.metrics.serviceMonitor.scrapeTimeout }}
    scrapeTimeout: {{ $dot.Values.metrics.serviceMonitor.scrapeTimeout }}
    {{- end }}
    {{- if $dot.Values.metrics.serviceMonitor.relabelings }}
    relabelings: {{- include "common.tplValue" ( dict "value" $dot.Values.metrics.serviceMonitor.relabelings "context" $dot) | nindent 6 }}
    {{- end }}
    {{- if $dot.Values.metrics.serviceMonitor.metricRelabelings }}
    metricRelabelings: {{- include "common.tplValue" ( dict "value" $dot.Values.metrics.serviceMonitor.metricRelabelings "context" $dot) | nindent 6 }}
    {{- end }}
  namespaceSelector:
    matchNames:
    - {{ include "common.namespace" $dot }}
  selector:
    {{- if $dot.Values.metrics.serviceMonitor.selector }}
    matchLabels: {{- include "common.tplValue" ( dict "value" $dot.Values.metrics.serviceMonitor.selector "context" $dot) | nindent 6 }}
    {{- else }}
    matchLabels: {{- include "common.labels" (dict "labels" $labels "dot" $dot) | nindent 6 }}
    {{- end }}
{{- end -}}
