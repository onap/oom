{{- define "so.certificate.container_importer" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{ include "common.certInitializer.initContainer" $subchartDot }}
{{- if $dot.Values.global.aafEnabled }}
- name: {{ include "common.name" $dot }}-msb-cert-importer
  image: {{ include "repositoryGenerator.repository" $subchartDot }}/{{ $dot.Values.global.aafAgentImage }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $subchartDot.Values.pullPolicy }}
  command:
  - "/bin/sh"
  args:
  - "-c"
  - |
    export $(grep '^c' {{ $subchartDot.Values.certInitializer.credsPath }}/mycreds.prop | xargs -0)
    keytool -import -trustcacerts -alias msb_root -file \
      /certificates/msb-ca.crt -keystore \
      "{{ $subchartDot.Values.certInitializer.credsPath }}/{{ $subchartDot.Values.aaf.trustore }}" \
      -storepass $cadi_truststore_password -noprompt
    export EXIT_VALUE=$?
    if [ "${EXIT_VALUE}" != "0" ]
    then
      echo "issue with password: $cadi_truststore_password"
      exit $EXIT_VALUE
    else
      keytool -importkeystore -srckeystore "{{ $subchartDot.Values.certInitializer.credsPath }}/truststoreONAPall.jks" \
        -srcstorepass {{ $subchartDot.Values.certInitializer.trustStoreAllPass }} \
        -destkeystore "{{ $subchartDot.Values.certInitializer.credsPath }}/{{ $subchartDot.Values.aaf.trustore }}" \
        -deststorepass $cadi_truststore_password -noprompt
        export EXIT_VALUE=$?
    fi
    exit $EXIT_VALUE
  volumeMounts:
  {{ include "common.certInitializer.volumeMount" $subchartDot | indent 2 | trim }}
  - name: {{ include "common.name" $dot }}-msb-certificate
    mountPath: /certificates
{{- end }}
{{- end -}}

{{- define "so.certificate.volumes" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{ include "common.certInitializer.volumes" $subchartDot }}
{{- if $dot.Values.global.aafEnabled }}
- name: {{ include "common.name" $dot }}-msb-certificate
  secret:
    secretName: {{ include "common.secret.getSecretNameFast" (dict "global" $subchartDot "uid" "so-onap-certs") }}
{{- end }}
{{- end -}}

{{- define "so.certificate.volumeMount" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{ include "common.certInitializer.volumeMount" $subchartDot }}
{{- end -}}

{{- define "so.certificates.env" -}}
{{-   $dot := default . .dot -}}
{{-   $initRoot := default $dot.Values.soHelpers .initRoot -}}
{{- $subchartDot := fromJson (include "common.subChartDot" (dict "dot" $dot "initRoot" $initRoot)) }}
{{-   if $dot.Values.global.aafEnabled }}
- name: TRUSTSTORE
  value: {{ $subchartDot.Values.certInitializer.credsPath }}/{{ $subchartDot.Values.aaf.trustore }}
{{-     if $dot.Values.global.security.aaf.enabled }}
- name: KEYSTORE
  value: {{ $subchartDot.Values.certInitializer.credsPath }}/org.onap.so.p12
{{-     end }}
{{-   end }}
{{- end -}}
