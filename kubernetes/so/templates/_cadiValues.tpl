{{- define "cadi.keys" -}}
cadiLoglevel: DEBUG
cadiKeyFile: /app/so.keyfile
cadiTrustStore: /app/trustStoreONAPAll.jks
cadiTruststorePassword: {{ .Values.global.so.cadi.cadiTruststorePassword }}
cadiLatitude: {{ .Values.global.so.cadi.cadiLatitude }}
cadiLongitude: {{ .Values.global.so.cadi.cadiLongitude }}
aafEnv: {{ .Values.global.so.cadi.aafEnv }}
aafApiVersion: 2.0
aafRootNs: org.onap.aaf
aafId: {{ .Values.global.so.cadi.aafId }}
aafPassword: {{ .Values.global.so.cadi.aafPassword }}
aafLocateUrl: {{ .Values.global.so.cadi.aafLocateUrl }}
aafUrl: {{ .Values.global.so.cadi.aafUrl }}
apiEnforcement: {{ .Values.global.so.cadi.apiEnforcement }}
{{- if (.Values.global.so.cadi.noAuthn) }}
noAuthn: {{ .Values.global.so.cadi.noAuthn }}
{{- end }}
{{- end }}
