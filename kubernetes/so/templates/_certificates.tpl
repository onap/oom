{{- define "so.certificate.container_importer" -}}
- name: {{ include "common.name" . }}-certs-importer
  image: "{{ include "common.repository" . }}/{{ .Values.global.soBaseImage }}"
  imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy }}
  command:
  - "/bin/sh"
  args:
  - "-c"
  - "update-ca-certificates --fresh && \
    cp -r {{ .Values.global.certificates.path }}/* /certificates"
  volumeMounts:
  - name: {{ include "common.name" . }}-certificates
    mountPath: /certificates
  - name: {{ include "common.name" . }}-onap-certificates
    mountPath: {{ .Values.global.certificates.share_path }}
{{- end -}}

{{- define "so.certificate.volume-mounts" -}}
- name: {{ include "common.name" . }}-certificates
  mountPath: {{ .Values.global.certificates.path }}
- name: {{ include "common.name" . }}-onap-certificates
  mountPath: {{ .Values.global.certificates.share_path }}
{{- end -}}

{{- define "so.certificate.volumes" -}}
- name: {{ include "common.name" . }}-certificates
  emptyDir:
    medium: Memory
- name: {{ include "common.name" . }}-onap-certificates
  secret:
    secretName: {{ include "common.secret.getSecretNameFast" (dict "global" . "uid" "so-onap-certs") }}
{{- end -}}
