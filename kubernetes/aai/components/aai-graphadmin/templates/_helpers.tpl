{{- define "aai.waitForSchemaCreation" -}}
- name: wait-for-schema-creation
  image: "{{ include "repositoryGenerator.image.curl" . }}"
  imagePullPolicy: IfNotPresent
  command: ["/bin/sh", "-c"]
  args:
    - |
      URL="{{ required "URL is required" (.Values.schemaInitCheckURL | default "http://aai-graphadmin:8449/isSchemaInitialized") }}"
      while true; do
        RESPONSE=$(curl -s $URL)
        if [ "$RESPONSE" = "true" ]; then
          echo "Request successful. Schema is initialized."
          exit 0
        else
          echo "Request unsuccessful. Schema is not yet initialized. Retrying in 3 seconds..."
          sleep 3
        fi
      done
  {{ include "common.containerSecurityContext" . | indent 2 | trim }}
{{- end -}}
