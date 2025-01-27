#!/bin/sh
health_check_http_code=$(curl -k --max-time 5 -o /dev/null -w '%{http_code}' -X GET --header "Accept: application/json" "{{ if .Values.global.disableHttp }}https://127.0.0.1:{{ .Values.ONBOARDING_BE.https_port }}{{- else -}}http://127.0.0.1:{{ .Values.ONBOARDING_BE.http_port }}{{- end -}}/onboarding-api/v1.0/healthcheck")
if [ "$health_check_http_code" -eq 200 ]; then
  exit 0
else
  echo "Health check http status: $health_check_http_code"
  exit 1
fi
