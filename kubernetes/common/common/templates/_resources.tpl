{{- /*
# Copyright © 2018 Amdocs, Bell Canada
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
*/ -}}

{{- /*
  Resolve the name of the common resource limit/request flavor.
  The value for .Values.flavor is used by default,
  unless either override mechanism is used.

  - .Values.global.flavor  : override default flavor for all charts
  - .Values.flavorOverride : override global and default flavor on a per chart basis
*/ -}}
{{- define "common.flavor" -}}
  {{if .Values.flavorOverride }}
    {{- printf "%s" .Values.flavorOverride -}}
  {{else}}
    {{- default .Values.flavor .Values.global.flavor -}}
  {{end}}
{{- end -}}

{{- /*
  Resolve the resource limit/request flavor using the desired flavor value.

  - .Values.resources  : YAML definition of resource limits.  The flavor key
                        is computed based on the common.flavor template and
                        is used as the selected resource limit through the pluck
  e.g:  resources:
          small:
            limits:
              cpu: "200m"
              memory: "4Gi"
            requests:
              cpu: "100m"
              memory: "1Gi"
          large:
            limits:
              cpu: "400m"
              memory: "8Gi"
            requests:
              cpu: "200m"
              memory: "2Gi"
          unlimited: {}
*/ -}}
{{- define "common.resources" -}}
{{- $flavor := include "common.flavor" . -}}
{{- toYaml (pluck $flavor .Values.resources | first) -}}
{{- end -}}
