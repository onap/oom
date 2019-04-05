{{/*
# Copyright © 2019 Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

{{/*
  apply kafka tls listener
*/}}
{{- define "kafka.listenerProtocol" -}}
   {{- if .Values.tls.enabledInternal -}}
    {{- printf "INTERNAL:SASL_SSL," -}}
   {{- else -}}
    {{- printf "INTERNAL:SASL_PLAINTEXT," -}}
   {{- end -}}
   {{- if .Values.tls.enabledExternal -}}
    {{- printf "EXTERNAL:SASL_SSL" -}}
   {{- else -}}
    {{- printf "EXTERNAL:SASL_PLAINTEXT" -}}
   {{- end -}}
{{- end -}}

{{- define "kafka.tlsVolumes" }}
    {{- if .Values.tls.certificateAuthority.enabled }}
    - name: {{ include "common.fullname" . }}-kafka-client-truststore
      hostPath:
        path: /etc/kafka-client-truststore/truststore
        type: File
    - name: {{ include "common.fullname" . }}-server-https-keystore
      hostPath:
        path: /config/server-https-keystore/keystore
        type: File
    {{- end }}
{{- end }}

{{- define "kafka.tlsVolumeMounts" }}
    {{- if .Values.tls.certificateAuthority.enabled }}
    - name: {{ include "common.fullname" . }}-kafka-client-truststore
      mountPath: /etc/kafka-client-truststore/truststore
      subPath: truststore
      readOnly: true
    - name: {{ include "common.fullname" . }}-server-https-keystore
      mountPath: /etc/server-https-keystore/keystore
      subPath: keystore
      readOnly: true
    {{- end }}
{{- end }}