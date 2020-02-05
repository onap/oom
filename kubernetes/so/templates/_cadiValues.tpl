{{- define "cadi.keys" -}}
cadiLoglevel: DEBUG
cadiKeyFile: /org.onap.so.keyfile
cadiTrustStore: /app/org.onap.so.trust.jks
cadiTruststorePassword: {{ .Values.global.app.cadi.cadiTruststorePassword }}
cadiLatitude: {{ .Values.global.app.cadi.cadiLatitude }}
cadiLongitude: {{ .Values.global.app.cadi.cadiLongitude }}
aafEnv: {{ .Values.global.app.cadi.aafEnv }}
aafApiVersion: 2.0
aafRootNs: {{ .Values.global.app.cadi.aafRootNs }}
aafId: {{ .Values.mso.config.cadi.aafId }}
aafPassword: {{ .Values.mso.config.cadi.aafPassword }}
aafLocateUrl: {{ .Values.global.app.cadi.aafLocateUrl }}
aafUrl: {{ .Values.global.app.cadi.aafUrl }}
apiEnforcement: {{ .Values.mso.config.cadi.apiEnforcement }}
{{- if (.Values.global.app.cadi.noAuthn) }}
noAuthn: {{ .Values.mso.config.cadi.noAuthn }}
{{- end }}
{{- end }}
