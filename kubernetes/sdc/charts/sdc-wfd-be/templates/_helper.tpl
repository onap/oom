{{- define "sdc-wfd-be.volumes" }}
    {{ if .Values.config.cassandraSSLEnabled }}
    - name: {{ include "common.fullname" . }}-cassandra-client-truststore
      hostPath:
        path: /etc/cassandra-client-truststore/truststore
        type: File
    {{- end }}
    {{ if .Values.config.serverSSLEnabled }}
    - name: {{ include "common.fullname" . }}-server-https-keystore
      hostPath:
        path: /config/server-https-keystore/keystore
        type: File
    {{- end }}
{{- end }}

{{- define "sdc-wfd-be.volumeMounts" }}
    {{ if .Values.config.cassandraSSLEnabled }}
    - name: {{ include "common.fullname" . }}-cassandra-client-truststore
      mountPath: /etc/cassandra-client-truststore/truststore
      subPath: truststore
      readOnly: true
    {{- end }}
    {{ if .Values.config.serverSSLEnabled }}
    - name: {{ include "common.fullname" . }}-server-https-keystore
      mountPath: /etc/server-https-keystore/keystore
      subPath: keystore
      readOnly: true
    {{- end }}
{{- end }}