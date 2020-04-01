#!/bin/bash
touch /test-pd2/my-dummy-template.yaml
cat > /test-pd2/my-dummy-template.yaml <<EOF
apiVersion: apps/v1
kind: Deployment
metadata:
  name: mariadb-deployment
  labels:
    app:  {{ $.Release.Name }}-mariadb-galera
spec:
  replicas: 1
  selector:
    matchLabels:
      app:  {{ $.Release.Name }}-mariadb-galera
  template:
    metadata:
      labels:
        app:  {{ $.Release.Name }}-mariadb-galera
    spec:
      containers:
      - name: mariadb-container
        image: nexus3.onap.org:10001/adfinissygroup/k8s-mariadb-galera-centos:v002
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
          value: onap
        - name: MYSQL_USER
          value: my-user
        - name: MYSQL_PASSWORD
          value: my-password
        - name: MYSQL_ROOT_PASSWORD
          value: "secretpassword"
      subdomain: mariadb-galera
      hostname: mariadb-deployment
        
EOF