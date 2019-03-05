#!/bin/sh
RET=1

while [[ RET -ne 0 ]]; do
    echo "Waiting for Elasticsearch to become ready before running sgadmin..."
    curl -XGET -k "https://localhost:{{ .Values.service.internalPort }}/" >/dev/null 2>&1
    RET=$?
    sleep 5
done