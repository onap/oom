# Copyright © 2018 AT&T USA
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
{{- define "cadi.keys" -}}
cadiLoglevel: DEBUG
cadiKeyFile: {{ .Values.global.app.cadi.cadiKeyFile }}
cadiTrustStore: {{ .Values.global.app.cadi.cadiTrustStore }} 
cadiTruststorePassword: {{ .Values.global.app.cadi.cadiTruststorePassword }}
cadiLatitude: {{ .Values.global.app.cadi.cadiLatitude }}
cadiLongitude: {{ .Values.global.app.cadi.cadiLongitude }}
aafEnv: {{ .Values.global.app.cadi.aafEnv }}
aafApiVersion: {{ .Values.global.app.cadi.aafApiVersion }}
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
