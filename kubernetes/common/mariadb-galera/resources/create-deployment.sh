#!/bin/sh
touch /upgrade/mariadb-upgrade-deployment.yaml
cat > /upgrade/mariadb-upgrade-deployment.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "common.fullname" . }}-upgrade-deployment
  labels:
    app:  {{ include "common.fullname" . }}
spec:
  replicas: 1
  selector:
    matchLabels:
      app:  {{ include "common.fullname" . }}
  template:
    metadata:
      labels:
        app:  {{ include "common.fullname" . }}
    spec:
      containers:
      - name: mariadb-container
        image: "{{ include "common.repository" . }}/{{ .Values.image }}"
        ports:
        - containerPort: 3306
          name: mariadb-galera
          protocol: TCP
        - containerPort: 4444
          name: sst
          protocol: TCP
        - containerPort: 4567
          name: replication
          protocol: TCP
        - containerPort: 4568
          name: ist
          protocol: TCP
        env:
        - name: POD_NAMESPACE
          valueFrom:
                fieldRef:
                  apiVersion: v1
                  fieldPath: metadata.namespace
        - name: MYSQL_USER
          value: {{ default "" .Values.config.userName | quote }}
        - name: MYSQL_PASSWORD
          valueFrom:
                secretKeyRef:
                  name: {{ template "common.fullname" . }}
                  key: user-password
        - name: MYSQL_ROOT_PASSWORD
          valueFrom:
                secretKeyRef:
                  name: {{ template "common.fullname" . }}
                  key: db-root-password
      subdomain: mariadb-galera
      hostname: mariadb-upgrade-deployment
EOF