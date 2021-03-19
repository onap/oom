{{- define "so.cadi.keys" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
cadiLoglevel: {{ $initRoot.cadi.logLevel }}
cadiKeyFile: {{ $initRoot.certInitializer.credsPath }}/{{ $initRoot.certInitializer.fqi_namespace }}.keyfile
cadiTrustStore: {{ $initRoot.certInitializer.credsPath }}/truststoreONAPall.jks
cadiTruststorePassword: ${TRUSTSTORE_PASSWORD}
cadiLatitude: {{ $initRoot.cadi.latitude }}
cadiLongitude: {{ $initRoot.cadi.longitude }}
aafEnv: {{ $initRoot.cadi.aafEnv }}
aafApiVersion: {{ $initRoot.cadi.aafApiVersion }}
aafRootNs: {{ $initRoot.cadi.aafRootNs }}
aafId: {{ $initRoot.cadi.aafId }}
aafPassword: {{ $initRoot.cadi.aafPassword }}
aafLocateUrl: {{ $initRoot.cadi.aafLocateUrl }}
aafUrl: {{ $initRoot.cadi.aafUrl }}
apiEnforcement: {{ $initRoot.cadi.apiEnforcement }}
{{- if ($initRoot.cadi.noAuthn) }}
noAuthn: {{ $initRoot.cadi.noAuthn }}
{{- end }}
{{- end }}
