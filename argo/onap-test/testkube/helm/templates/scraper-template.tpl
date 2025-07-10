{{- define "scraper.template" }}
{{/* Define scraper.template */}}
scraperTemplate: |
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
        - name: {{ printf "\"{{ .Name }}-scraper\"" }}
          {{ printf "{{- if .Registry }}" }}
          image: {{ printf "{{ .Registry }}/{{ .ScraperImage }}" }}
          {{ printf "{{- else }}" }}
          image: {{ printf "{{ .ScraperImage }}" }}
          {{ printf "{{- end }}" }}
          imagePullPolicy: Always
          command:
          - "/bin/runner"
          - {{ printf "'{{ .Jsn }}'" }}
{{ end -}}
