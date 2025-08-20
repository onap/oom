#!/bin/sh
CASSANDRA_IP={{ .Values.global.sdc_cassandra.serviceName }}.{{ include "common.namespace" . }}.svc.cluster.local
CASSANDRA_PORT={{ .Values.cassandraConfiguration.cassandraPort }}
SDC_USER="$SDC_USER"
SDC_PASSWORD="$SDC_PASSWORD"

retry_num=1
is_up=0
while [ $is_up -eq 0 -a $retry_num -le 100 ]; do
   echo "exit" | cqlsh -u {{ .Values.global.sdc_cassandra.username }} -p {{ .Values.global.sdc_cassandra.password }} $CASSANDRA_IP $CASSANDRA_PORT --cqlversion="{{ .Values.cassandraConfiguration.cql_version }}"
   res1=$?
   if [ $res1 -eq 0 ]; then
      echo "`date` --- cqlsh is able to connect."
      is_up=1
   else
      echo "`date` --- cqlsh is NOT able to connect yet. sleep 5"
      sleep 5
   fi
   retry_num=$((retry_num+1))
done

cassandra_user_exist=$(echo "list users;" | cqlsh -u {{ .Values.global.sdc_cassandra.username }} -p {{ .Values.global.sdc_cassandra.password }} $CASSANDRA_IP $CASSANDRA_PORT --cqlversion="{{ .Values.cassandraConfiguration.cql_version }}" | grep -c $SDC_USER)
if [ $cassandra_user_exist -eq 1 ]; then
    echo "Cassandra user $SDC_USER already exists"
else
    echo "Going to create $SDC_USER"
    echo "create user $SDC_USER with password '$SDC_PASSWORD' nosuperuser;" | cqlsh -u {{ .Values.global.sdc_cassandra.username }} -p {{ .Values.global.sdc_cassandra.password }} $CASSANDRA_IP $CASSANDRA_PORT --cqlversion="{{ .Values.cassandraConfiguration.cql_version }}"
fi
