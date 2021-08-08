{{/*
# Copyright © 2021 Bell Canada
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
  Generate comma separated list of kafka or zookeper nodes to reuse in message router charts.
  How to use:

  zookeeper servers list: {{ include "common.kafkaNodes" (dict "dot" . "replicaCount" (index .Values "message-router-zookeeper" "replicaCount") "componentName" .Values.zookeeper.name "port" .Values.zookeeper.port ) }}
  kafka servers list: {{ include "common.kafkaNodes" (dict "dot" . "replicaCount" (index .Values "message-router-kafka" "replicaCount") "componentName" .Values.kafka.name "port" .Values.kafka.port ) }}

*/}}
{{- define "common.kafkaNodes" -}}
{{- $dot := .dot -}}
{{- $replicaCount := .replicaCount -}}
{{- $componentName := .componentName -}}
{{- $port := .port -}}
{{- $kafkaNodes := list -}}
{{- range $i, $e := until (int $replicaCount) -}}
{{- $kafkaNodes = print (include "common.release" $dot) "-" $componentName "-" $i "." $componentName "." (include "common.namespace" $dot) ".svc.cluster.local:" $port | append $kafkaNodes -}}
{{- end -}}
{{- $kafkaNodes | join "," -}}
{{- end -}}
