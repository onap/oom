#!/bin/sh
touch /upgrade/mariadb-upgrade-deployment.yaml
cat > /upgrade/mariadb-upgrade-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}-upgrade-deployment
  labels:
    app:  {{ include "common.fullname" . }}
    component: upgrade
spec:
  replicas: 1
  selector:
    matchLabels:
      app:  {{ include "common.fullname" . }}
      component: upgrade
  template:
    metadata:
      labels:
        app:  {{ include "common.fullname" . }}
        component: upgrade
    spec:
      containers:
      - name: mariadb-container
        image: "{{ include "common.repository" . }}/{{ .Values.image }}"
        imagePullPolicy: {{ .Values.global.pullPolicy | default .Values.pullPolicy | quote}}
        ports:
        - containerPort: {{ .Values.service.internalPort }}
          name: {{ .Values.service.portName }}
        - containerPort: {{ .Values.service.sstPort }}
          name: {{ .Values.service.sstPortName }}
        - containerPort: {{ .Values.service.replicationPort }}
          name: {{ .Values.service.replicationName }}
        - containerPort: {{ .Values.service.istPort }}
          name: {{ .Values.service.istPortName }}
        env:
        - name: POD_NAMESPACE
          valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
        - name: MYSQL_USER
          {{- include "common.secret.envFromSecretFast" (dict "global" . "uid" (include "common.mariadb.secret.userCredentialsUID" .) "key" "login") | indent 12}}
        - name: MYSQL_PASSWORD
          {{- include "common.secret.envFromSecretFast" (dict "global" . "uid" (include "common.mariadb.secret.userCredentialsUID" .) "key" "password") | indent 12}}
        - name: MYSQL_DATABASE
          value: {{ default "" .Values.config.mysqlDatabase | quote }}
        - name: MYSQL_ROOT_PASSWORD
          {{- include "common.secret.envFromSecretFast" (dict "global" . "uid" (include "common.mariadb.secret.rootPassUID" .) "key" "password") | indent 12}}
      subdomain: {{ .Values.service.name }}
      hostname: mariadb-upgrade-deployment
EOF
