{{/*
# Copyright © 2019 Amdocs, Bell Canada
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

{{- /*
    Calculate the maximum number of zk server down in order to guarantee ZK quorum.
    For guaranteeing ZK quorum we need half of the server + 1 up.

    div in go template cast return an int64
    so we need to know if it is an even number or an odd.
    For this we are doing (n/2)*2=n?
    if true it is even else it is even
*/ -}}
{{- define "zk.maxUnavailable" -}}
{{- $halfReplica := div .Values.replicaCount 2 -}}
 {{/* divide by 2 and multiply by 2 in order to know if it is an even number*/}}
    {{if eq (mul $halfReplica 2) (int .Values.replicaCount) }}
        {{- toYaml  (sub $halfReplica 1) -}}
    {{else}}
        {{- toYaml $halfReplica -}}
    {{end}}
{{- end -}}
