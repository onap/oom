{{/*
# Copyright © 2022 Nordix Foundation
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
  Create a Strimzi KafkaUser.
  Usage:
      include "common.kafkauser" .

  Strimzi kafka provides cluster access via its custom resource definition KafkaUser
  which is deployed using its User Operator component.
  See more info here - https://github.com/strimzi/strimzi-kafka-operator/blob/main/helm-charts/helm3/strimzi-kafka-operator/crds/044-Crd-kafkauser.yaml
  This allows fine grained access control per user towards the kafka cluster.
  See more info here - https://strimzi.io/docs/operators/latest/configuring.html#proc-configuring-kafka-user-str

  The kafka user definition is defined as part of .Values per component.
  For general use by OOM components, the following list of acl types should suffice:
       type: group (Used by the client app to be added to a particular kafka consumer group)
       type: topic (1 or more kafka topics that the client needs to access. Commonly [Read,Write])

  Note: The template will use the following default values.

    spec.authentication.type: scram-sha-512 (dictated by the available broker listeners on the kafka cluster)
    spec.authorization.type: simple (Only type supported by strimzi at present)
    spec.authorization.acls.resource.patternType: literal

  Example:

  kafkaUser:
    acls:
      - name: sdc (mandatory)
        suffix: mysuffix (optional. Will be appended (with a hyphen) to the "name" entry. ie "sdc-mysuffix")
        type: group (mandatory. Type "group" is used by the client as it's kafka consumer group)
        operations: [Read] (mandatory. List of at least 1)
      - name: SDC-DISTR
        type: topic
        patternType: prefix (optional. In this example, the user will be provided Read and Write access to all topics named "SDC-DISTR*")
        operations: [Read, Write]
*/}}
{{- define "common.kafkauser" -}}
{{- $global := .global }}
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaUser
metadata:
  name: {{ include "common.name" . }}-ku
  labels:
    strimzi.io/cluster: {{ include "common.release" . }}-strimzi
spec:
  authentication:
    type: {{ .Values.kafkaUser.authenticationType | default "scram-sha-512" }}
  authorization:
    type: {{ .Values.kafkaUser.authorizationType | default "simple" }}
    acls:
      {{- range $acl := .Values.kafkaUser.acls }}
      - resource:
          type: {{ $acl.type }}
          patternType: {{ $acl.patternType | default "literal" }}
          name: {{ ternary (printf "%s-%s" $acl.name $acl.suffix) $acl.name (hasKey $acl "suffix") }}
        operations:
        {{- range $operation := $acl.operations }}
          - {{ . }}
        {{- end }}
      {{- end }}
{{- end -}}

{{/*
  Create a Strimzi KafkaTopic.
  Usage:
      include "common.kafkatopic" .

  Strimzi kafka provides kafka topic management via its custom resource definition KafkaTopic
  which is deployed using its Topic Operator component.
  See more info here - https://github.com/strimzi/strimzi-kafka-operator/blob/main/helm-charts/helm3/strimzi-kafka-operator/crds/043-Crd-kafkatopic.yaml

  Note: KafkaTopic names should adhere to kubernetes object naming conventions - https://kubernetes.io/docs/concepts/overview/working-with-objects/names/
        maximum length of 253 characters and consist of lower case alphanumeric characters, -, and .

  Note: The template will use the following default values.

    spec.config.retention.ms: 7200000 (defaults to 2 hrs retention for kafka topic logs)
    spec.config.segment.bytes: 1073741824 (defaults to 1gb)
    spec.partitions: 6 (defaults to (2 * (default.replication.factor)) defined by the strimzi broker conf)
    spec.replicas: 3 (defaults to default.replication.factor defined by the strimzi broker conf. Must be > 0 and <= (num of broker replicas))

  The kafka topic definition is defined as part of .Values per component.

  Example:

  kafkaTopic:
    - name: my-new-topic (mandatory)
      retentionMs: 7200000 (optional. Defaults to 2hrs)
      segmentBytes: 1073741824 (optional. Defaults to 1gb)
      suffix: my-suffix (optional. Will be appended (with a hyphen) to the "name" value. ie "my-new-topic-my-suffix")
    - name: my.other.topic
      suffix: some.other-suffix
*/}}
{{- define "common.kafkatopic" -}}
{{- $global := .global }}
{{- range $topic := .Values.kafkaTopic }}
apiVersion: kafka.strimzi.io/v1beta2
kind: KafkaTopic
metadata:
  {{- if (hasKey $topic "strimziTopicName") }}
  name: {{ ($topic.strimziTopicName) }}-kt
  {{- else }}
  name: {{ ($topic.name) | lower }}-kt
  {{- end }}
  labels:
    strimzi.io/cluster: {{ include "common.release" $ }}-strimzi
spec:
  {{- if (hasKey $topic "partitions") }}
  partitions: {{ $topic.partitions }}
  {{- end }}
  {{- if (hasKey $topic "replicas") }}
  replicas: {{ $topic.replicas }}
  {{- end }}
  topicName: {{ ternary (printf "%s-%s" $topic.name $topic.suffix) $topic.name (hasKey $topic "suffix") }}
  config:
    retention.ms: {{ $topic.retentionMs | default "7200000" }}
    segment.bytes: {{ $topic.segmentBytes | default "1073741824"}}
---
{{- end }}
{{- end -}}
