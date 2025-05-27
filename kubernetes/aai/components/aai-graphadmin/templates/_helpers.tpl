{{- define "aai.waitForSchemaService" -}}
- name: wait-for-schema-service
  image: "{{ include "repositoryGenerator.image.curl" . }}"
  imagePullPolicy: IfNotPresent
  command: ["/bin/sh", "-c"]
  args:
    - |
      URL="{{ required "URL is required" (.Values.schemaInitCheckURL | default "http://aai-schema-service:8452/aai/schema-service/util/echo") }}"
      AUTH="{{ printf "%s:%s" (index .Values.global.auth.users 0).username (index .Values.global.auth.users 0).password }}"
      while true; do
        if curl --fail --header 'X-FromAppId: graphadmin' --header 'X-TransactionId: someTransaction' -u $AUTH -s $URL; then
          echo "Request successful. Schema-service is available"
          exit 0
        else
          echo "Request unsuccessful. Schema-service is not available yet. Retrying in 3 seconds..."
          sleep 3
        fi
      done
  {{ include "common.containerSecurityContext" . | indent 2 | trim }}
{{- end -}}
