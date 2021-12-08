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

{{/*
  Calculate if we are on service mesh.
*/}}
{{- define "common.onServiceMesh" -}}
{{-   if .Values.global.serviceMesh -}}
{{-     if (default false .Values.global.serviceMesh.enabled) -}}
true
{{-     end -}}
{{-   end -}}
{{- end -}}

{{/*
  Kills the sidecar proxy associated with a pod.
*/}}
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

{{/*
  Wait for job container.
*/}}
{{- define "common.waitForJobContainer" -}}
{{-   $dot := default . .dot -}}
{{-   $wait_for_job_container := default $dot.Values.wait_for_job_container .wait_for_job_container -}}
{{- if (include "common.onServiceMesh" .) }}
- name: {{ include "common.name" $dot }}{{ ternary "" (printf "-%s" $wait_for_job_container.name) (empty $wait_for_job_container.name) }}-service-mesh-wait-for-job-container
  image: {{ include "repositoryGenerator.image.quitQuit" $dot }}
  imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
  command:
  - /bin/sh
  - "-c"
  args:
  - echo "waiting 10s for istio side cars to be up"; sleep 10s;
    {{- range $container := $wait_for_job_container.containers }}
    /app/ready.py --service-mesh-check {{ tpl $container $dot }} -t 45;
    {{- end }}
  env:
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        apiVersion: v1
        fieldPath: metadata.namespace
{{- end }}
{{- end }}
