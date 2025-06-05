{{- define "job.template" }}
{{/* Define job.template */}}
jobTemplate: |
  apiVersion: batch/v1
  kind: Job
  metadata:
    annotations:
      argocd.argoproj.io/compare-options: IgnoreExtraneous
      argocd.argoproj.io/sync-options: Prune=false
  spec:
    template:
      spec:
        serviceAccountName: {{ .Release.Name }}-tests-service-account
        containers:
        - name: {{ printf "\"{{ .Name }}\"" }}
          image: {{ printf "{{ .Image }}" }}
          imagePullPolicy: Always
{{ end -}}
