{{- define "common.configmap" -}}
{{- $global := . }}
{{- range $configMap := .Values.configMaps }}
---
apiVersion: v1
kind: ConfigMap
metadata:
  name: {{ tpl $configMap.name $global }}
  namespace: {{ include "common.namespace" $global }}
  labels:
    app: {{ include "common.name" $global }}
    chart: {{ $global.Chart.Name }}-{{ $global.Chart.Version | replace "+" "_" }}
    release: {{ $global.Release.Name }}
    heritage: {{ $global.Release.Service }}
data:
{{- range $curFilePath := $configMap.filePaths }}
{{ tpl ($global.Files.Glob $curFilePath).AsConfig $global | indent 2 }}
{{- end }}
{{ if $configMap.filePath }}
{{ tpl ($global.Files.Glob $configMap.filePath).AsConfig $global | indent 2 }}
{{ end }}
{{- end }}
{{- end -}}
