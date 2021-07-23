{{/*
# Copyright © 2020 Amdocs, Bell Canada, Orange
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


{/*
  Calculate if we are on service mesh.
*/}}
{{- define "common.onServiceMesh" -}}
{{-   if .Values.global.serviceMesh -}}
{{-     if (default false .Values.global.serviceMesh.enabled) -}}
true
{{-     end -}}
{{-   end -}}
{{- end -}}

{{- define "common.serviceMesh.killSidecar" -}}
{{-   if (include "common.onServiceMesh" .) }}
RCODE="$?";
echo "*** script finished with exit code $RCODE" ;
echo "*** killing service mesh sidecar" ;
curl -sf -X POST http://127.0.0.1:15020/quitquitquit ;
echo "" ;
echo "*** exiting with script exit code" ;
exit "$RCODE"
{{-   end }}
{{- end -}}
