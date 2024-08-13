{{- define "oof.etcd.env" -}}
- name: OS_ETCD_API__USERNAME
  {{- include "common.secret.envFromSecretFast" (dict "global" . "uid" "oof-has-etcd-secret" "key" "login") | indent 2 }}
- name: OS_ETCD_API__PASSWORD
  {{- include "common.secret.envFromSecretFast" (dict "global" . "uid" "oof-has-etcd-secret" "key" "password") | indent 2 }}
{{- end -}}