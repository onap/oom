{{/*
# Copyright © 2019 Samsung Electronics
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
  UID of postgres root password
*/}}
{{- define "common.postgres.secret.rootPassUID" -}}
  {{- printf "db-root-password" }}
{{- end -}}

{{/*
  Name of postgres secret
*/}}
{{- define "common.postgres.secret._secretName" -}}
  {{- $global := .dot }}
  {{- $chartName := tpl .chartName $global -}}
  {{- include "common.secret.genName" (dict "global" $global "uid" (include .uidTemplate $global) "chartName" $chartName) }}
{{- end -}}

{{/*
  Name of postgres root password secret
*/}}
{{- define "common.postgres.secret.rootPassSecretName" -}}
  {{- include "common.postgres.secret._secretName" (set . "uidTemplate" "common.postgres.secret.rootPassUID") }}
{{- end -}}

{{/*
  UID of postgres user credentials
*/}}
{{- define "common.postgres.secret.userCredentialsUID" -}}
  {{- printf "db-user-credentials" }}
{{- end -}}

{{/*
  Name of postgres user credentials secret
*/}}
{{- define "common.postgres.secret.userCredentialsSecretName" -}}
  {{- include "common.postgres.secret._secretName" (set . "uidTemplate" "common.postgres.secret.userCredentialsUID") }}
{{- end -}}

{{/*
  UID of postgres primary password
*/}}
{{- define "common.postgres.secret.primaryPasswordUID" -}}
  {{- printf "primary-password" }}
{{- end -}}

{{/*
  Name of postgres user credentials secret
*/}}
{{- define "common.postgres.secret.primaryPasswordSecretName" -}}
  {{- include "common.postgres.secret._secretName" (set . "uidTemplate" "common.postgres.secret.primaryPasswordUID") }}
{{- end -}}
{{/*
  Create postgres Database via postgres crunchydata-operator
*/}}
{{- define "common.postgresOpDatabase" -}}
{{- $dot := default . .dot -}}
{{- $dbname := (required "'dbame' param, is required." .dbname) -}}
{{- $dbinst := (required "'dbinst' param, is required." .dbinst) -}}
---
apiVersion: postgres-operator.crunchydata.com/v1beta1
kind: PostgresCluster
metadata:
  name: {{ $dbname }}
spec:
  image: registry.developers.crunchydata.com/crunchydata/crunchy-postgres:ubi8-15.4-0
  postgresVersion: 15
  instances:
    - name: instance1
      dataVolumeClaimSpec:
        accessModes:
        - "ReadWriteOnce"
        resources:
          requests:
            storage: 2Gi
  backups:
    pgbackrest:
      restore:
        enabled: true
        repoName: repo1
      manual:
        repoName: repo1
        options:
          - --type=full
      global:
        repo1-path: /pgbackrest/repo1
        repo1-retention-full: "3"
        repo1-retention-full-type: time
      image: registry.developers.crunchydata.com/crunchydata/crunchy-pgbackrest:ubi8-2.47-0
      repos:
      - name: repo1
        schedules:
          full: "0 1 * * *"
          incremental: "0 */2 * * *"
        volume:
          volumeClaimSpec:
            accessModes:
            - "ReadWriteOnce"
            resources:
              requests:
                storage: 2Gi
{{- end -}}
