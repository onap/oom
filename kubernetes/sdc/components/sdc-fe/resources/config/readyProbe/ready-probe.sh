#!/bin/sh
# Determine the protocol and ports from Helm values
disableHttp={{ .Values.disableHttp | quote }}  # Use the value from values.yaml
http_port={{ .Values.fe_conf.http_port | quote }}       # Use the HTTP port from values.yaml
https_port={{ .Values.fe_conf.https_port | quote }}     # Use the HTTPS port from values.yaml

# Determine the protocol and port
if [ "$disableHttp" = "true" ]; then
  protocol="https"
  port="$https_port"
else
  protocol="http"
  port="$http_port"
fi

# Perform health check
health_check_http_code=$(curl -k --max-time 5 -o /dev/null -w '%{http_code}' "$protocol://127.0.0.1:$port/sdc1/rest/healthCheck")

# Output the health check result
echo "Health check http status: $health_check_http_code"

# Check if the response code is 200
if [ "$health_check_http_code" -eq 200 ]; then
  exit 0
else
  exit 1
fi
