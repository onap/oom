{{- define "oof.certificate.volume" -}}
- name: {{ include "common.fullname" . }}-onap-certs
  secret:
    secretName: {{ include "common.secret.getSecretNameFast" (dict "global" . "uid" "oof-onap-certs") }}
    items:
    - key: aaf_root_ca.cer
      path: aaf_root_ca.cer
    - key: intermediate_root_ca.pem
      path: intermediate_root_ca.pem
{{- end -}}

