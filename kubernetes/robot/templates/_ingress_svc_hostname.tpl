{{/*
# Copyright © 2020 Samsung Electronics
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
  For internal use only!

  Return true value if robot via ingress test is enabled

  The template takes two arguments:
     - .parent: environment (.)
     - .key: robot test component name
*/}}

{{- define "robot.ingress.svchost._isen" -}}
  {{- $key := .key -}}
  {{- $master := .parent.Values.config.useIngressHost -}}
  {{- if hasKey $master "enabled" -}}
    {{- if (index $master "enabled") -}}
      {{- if hasKey $master $key -}}
        {{- $en_parent := (index $master $key) -}}
        {{- if hasKey $en_parent "enabled" -}}
          {{- default "" (index $en_parent "enabled") -}}
        {{- else -}}
          {{- "" -}}
        {{- end -}}
      {{- else -}}
        {{- "" -}}
      {{- end -}}
  {{- else -}}
    {{- "" -}}
  {{- end -}}
 {{- else -}}
   {{- "" -}}
 {{- end -}}
{{- end -}}

{{/*
  For internal use only!

  Return ingress alternative hotname if present

  The template takes two arguments:
     - .parent: environment (.)
     - .key: robot test component name
*/}}

{{- define "robot.ingress.svchost._inghost" -}}
  {{- $key := .key -}}
  {{- $master := .parent.Values.config.useIngressHost -}}
  {{- if hasKey $master $key -}}
    {{- $h_parent := (index $master $key) -}}
    {{- if hasKey $h_parent "hostname" -}}
      {{- default "" (index $h_parent "hostname") -}}
    {{- else -}}
      {{- "" -}}
    {{- end -}}
  {{- else -}}
    {{- "" -}}
  {{- end -}}
{{- end -}}

{{/*
  For internal use only!

  Return robot target port depending on the robot test configuration
  or default value if config is not available

  The template takes two arguments:
     - .parent: environment (.)
     - .key: robot test component name
*/}}
{{- define "robot.ingress.svchost._port" -}}
  {{- $key := .key -}}
  {{- $master := .parent.Values.config.useIngressHost -}}
  {{- if hasKey $master $key -}}
    {{- $https_parent := (index $master $key) -}}
    {{- if hasKey $https_parent "https" -}}
      {{- $ishttps := (index $https_parent "https") -}}
      {{- ternary 443 80 $ishttps -}}
    {{- else -}}
      {{- 80 -}}
    {{- end -}}
  {{- else -}}
    {{- 80 -}}
  {{- end -}}
{{- end -}}

{{/*
  Return the hostname for tested compoment by robot
  if the ingress is enabled it return cluster ingress
  controller hostname. If the ingress controller in robot
  test is disabled it returns the internal cluster hostname

  The template takes two arguments:
     - .root: root environment (.)
     - .hostname: basename of host

  Return string target hostname for robot test on particular component
*/}}
{{- define "robot.ingress.svchost" -}}
  {{- $hostname := required "service hostname" .hostname -}}
  {{- $tplhname := $hostname | replace "-" "_" -}}
  {{- $ingress_enabled := include "robot.ingress.svchost._isen" (dict "parent" .root "key" $tplhname) -}}
  {{- if $ingress_enabled -}}
    {{- if .root.Values.global.ingress -}}
    {{- if .root.Values.global.ingress.virtualhost -}}
      {{- $domain := .root.Values.global.ingress.virtualhost.baseurl -}}
      {{- $ihostname := default $hostname (include "robot.ingress.svchost._inghost" (dict "parent" .root "key" $tplhname)) -}}
      {{- printf "%s.%s" $ihostname $domain -}}
    {{- end -}}
    {{- end -}}
  {{- else -}}
    {{- $domain := include "common.namespace" .root -}}
    {{- printf "%s.%s" $hostname $domain -}}
  {{- end -}}
{{- end -}}


{{/*
  Return the target port for the robot testing purpose
  if the ingress is enabled it return cluster ingress
  controller port. If the target port doesn't exists
  it return default port

  The template takes three arguments:
     - .root: root environment (.)
     - .hostname: basename of host
     - .port Default target port

  Return target port for tested components
*/}}
{{- define "robot.ingress.port" -}}
  {{- $hostname := required "service hostname" .hostname -}}
  {{- $port := required "service port" .port -}}
  {{- $tplhname := $hostname | replace "-" "_" -}}
  {{- $ingress_enabled := include "robot.ingress.svchost._isen" (dict "parent" .root "key" $tplhname) -}}
  {{- if $ingress_enabled -}}
    {{- include "robot.ingress.svchost._port" (dict "parent" .root "key" $tplhname) -}}
  {{- else -}}
    {{- printf "%d" $port -}}
  {{- end -}}
{{- end -}}

