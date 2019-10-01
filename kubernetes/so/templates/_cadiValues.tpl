{{- define "cadi.keys" -}}
cadiLoglevel: DEBUG
cadiKeyFile: /so.keyfile
cadiTrustStore: /app/trustStoreONAPAll.jks
cadiTruststorePassword: {{ .Values.global.app.cadi.cadiTruststorePassword }}
cadiLatitude: {{ .Values.global.app.cadi.cadiLatitude }}
cadiLongitude: {{ .Values.global.app.cadi.cadiLongitude }}
aafEnv: {{ .Values.global.app.cadi.aafEnv }}
aafApiVersion: 2.0
aafRootNs: org.onap.aaf
aafId: {{ .Values.global.app.cadi.aafId }}
aafPassword: {{ .Values.global.app.cadi.aafPassword }}
aafLocateUrl: {{ .Values.global.app.cadi.aafLocateUrl }}
aafUrl: {{ .Values.global.app.cadi.aafUrl }}
apiEnforcement: {{ .Values.global.app.cadi.apiEnforcement }}
{{- if (.Values.global.app.cadi.noAuthn) }}
noAuthn: {{ .Values.global.app.cadi.noAuthn }}
{{- end }}
{{- end }}
