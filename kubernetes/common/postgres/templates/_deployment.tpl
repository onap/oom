{{/*
# Copyright © 2018 Amdocs, AT&T, Bell Canada
# Copyright © 2020 Samsung Electronics
# Copyright © 2021 Orange
# Modifications Copyright (C) 2021 Bell Canada.
# #
# # Licensed under the Apache License, Version 2.0 (the "License");
# # you may not use this file except in compliance with the License.
# # You may obtain a copy of the License at
# #
# #       http://www.apache.org/licenses/LICENSE-2.0
# #
# # Unless required by applicable law or agreed to in writing, software
# # distributed under the License is distributed on an "AS IS" BASIS,
# # WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# # See the License for the specific language governing permissions and
# # limitations under the License.
*/}}

{{- define "common.postgres.deployment" -}}
  {{- $dot := .dot }}
  {{- $pgMode := .pgMode }}
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" $dot }}-{{ $pgMode }}
  namespace: {{ include "common.namespace" $dot }}
  labels:
    app: {{ include "common.name" $dot }}-{{ $pgMode }}
    chart: {{ $dot.Chart.Name }}-{{ $dot.Chart.Version | replace "+" "_" }}
    release: {{ include "common.release" $dot }}
    heritage: {{ $dot.Release.Service }}
    name: "{{ index $dot.Values "container" "name" $pgMode }}"
spec:
  replicas: 1
  strategy:
    type: Recreate
  selector:
    matchLabels:
      app: {{ include "common.name" $dot }}-{{ $pgMode }}
  template:
    metadata:
      labels:
        app: {{ include "common.name" $dot }}-{{ $pgMode }}
        release: {{ include "common.release" $dot }}
        name: "{{ index $dot.Values "container" "name" $pgMode }}"
    spec:
      imagePullSecrets:
      - name: "{{ include "common.namespace" $dot }}-docker-registry-key"
      initContainers:
      - command:
        - sh
        args:
        - -c
        - |
          function prepare_password {
            echo -n $1 | sed -e "s/'/''/g"
          }
          export PG_PRIMARY_PASSWORD=`prepare_password $PG_PRIMARY_PASSWORD_INPUT`;
          export PG_PASSWORD=`prepare_password $PG_PASSWORD_INPUT`;
          export PG_ROOT_PASSWORD=`prepare_password $PG_ROOT_PASSWORD_INPUT`;
          cd /config-input && for PFILE in `ls -1 .`; do envsubst <${PFILE} >/config/${PFILE}; done
        env:
        - name: PG_PRIMARY_USER
          value: primaryuser
        - name: MODE
          value: postgres
        - name: PG_PRIMARY_PASSWORD_INPUT
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.primaryPasswordUID" .) "key" "password") | indent 10 }}
        - name: PG_USER
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.userCredentialsUID" .) "key" "login") | indent 10 }}
        - name: PG_PASSWORD_INPUT
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.userCredentialsUID" .) "key" "password") | indent 10 }}
        - name: PG_DATABASE
          value: "{{ $dot.Values.config.pgDatabase }}"
        - name: PG_ROOT_PASSWORD_INPUT
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.rootPassUID" .) "key" "password") | indent 10 }}
        volumeMounts:
        - mountPath: /config-input/setup.sql
          name: config
          subPath: setup.sql
        - mountPath: /config
          name: pgconf
        image: {{ include "repositoryGenerator.image.envsubst" $dot }}
        imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
        name: {{ include "common.name" $dot }}-update-config

      - name: init-sysctl
        command:
        - /bin/sh
        - -c
        - |
          chown 26:26 /podroot/;
          chmod 700 /podroot/;
        image: {{ include "repositoryGenerator.image.busybox" $dot }}
        imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
        volumeMounts:
        - name: {{ include "common.fullname" $dot }}-data
          mountPath: /podroot/
      containers:
      - name: {{ include "common.name" $dot }}
        image: {{ include "repositoryGenerator.image.postgres" $dot }}
        imagePullPolicy: {{ $dot.Values.global.pullPolicy | default $dot.Values.pullPolicy }}
        ports:
        - containerPort: {{ $dot.Values.service.internalPort }}
          name: {{ $dot.Values.service.portName }}
        # disable liveness probe when breakpoints set in debugger
        # so K8s doesn't restart unresponsive container
        {{- if eq $dot.Values.liveness.enabled true }}
        livenessProbe:
          tcpSocket:
            port: {{ $dot.Values.service.internalPort }}
          initialDelaySeconds: {{ $dot.Values.liveness.initialDelaySeconds }}
          periodSeconds: {{ $dot.Values.liveness.periodSeconds }}
          timeoutSeconds: {{ $dot.Values.liveness.timeoutSeconds }}
        {{- end }}
        readinessProbe:
          tcpSocket:
            port: {{ $dot.Values.service.internalPort }}
          initialDelaySeconds: {{ $dot.Values.readiness.initialDelaySeconds }}
          periodSeconds: {{ $dot.Values.readiness.periodSeconds }}
        env:
        - name: PGHOST
          value: /tmp
        - name: PG_PRIMARY_USER
          value: primaryuser
        - name: MODE
          value: postgres
        - name: PG_MODE
          value: {{ $pgMode }}
        - name: PG_PRIMARY_HOST
          value: "{{ $dot.Values.service.name2 }}"
        - name: PG_REPLICA_HOST
          value: "{{ $dot.Values.service.name3 }}"
        - name: PG_PRIMARY_PORT
          value: "{{ $dot.Values.service.internalPort }}"
        - name: PG_PRIMARY_PASSWORD
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.primaryPasswordUID" .) "key" "password") | indent 10 }}
        - name: PG_USER
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.userCredentialsUID" .) "key" "login") | indent 10 }}
        - name: PG_PASSWORD
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.userCredentialsUID" .) "key" "password") | indent 10 }}
        - name: PG_DATABASE
          value: "{{ $dot.Values.config.pgDatabase }}"
        - name: PG_ROOT_PASSWORD
          {{- include "common.secret.envFromSecretFast" (dict "global" $dot "uid" (include "common.postgres.secret.rootPassUID" .) "key" "password") | indent 10 }}
        - name: PGDATA_PATH_OVERRIDE
          value: "{{ $dot.Values.config.pgDataPath }}"
        volumeMounts:
        - name: config
          mountPath: /pgconf/pool_hba.conf
          subPath: pool_hba.conf
        - name: pgconf
          mountPath: /pgconf/setup.sql
          subPath: setup.sql
        - mountPath: /pgdata
          name: {{ include "common.fullname" $dot }}-data
        - mountPath: /backup
          name: {{ include "common.fullname" $dot }}-backup
          readOnly: true
        resources: {{ include "common.resources" $dot | nindent 12 }}
        {{- if $dot.Values.nodeSelector }}
        nodeSelector:
{{ toYaml $dot.Values.nodeSelector | indent 10 }}
        {{- end -}}
        {{- if $dot.Values.affinity }}
        affinity:
{{ toYaml $dot.Values.affinity | indent 10 }}
        {{- end }}
      volumes:
      - name: localtime
        hostPath:
          path: /etc/localtime
      - name: {{ include "common.fullname" $dot }}-backup
        emptyDir: {}
      - name: {{ include "common.fullname" $dot }}-data
{{- if $dot.Values.persistence.enabled }}
        persistentVolumeClaim:
            claimName: {{ include "common.fullname" $dot }}-{{ $pgMode }}
{{- else }}
        emptyDir: {}
{{ end }}
      - name: config
        configMap:
          name: {{ include "common.fullname" $dot }}
      - name: pgconf
        emptyDir:
          medium: Memory
{{- end -}}
