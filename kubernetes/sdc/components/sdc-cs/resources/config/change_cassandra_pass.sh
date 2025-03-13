#!/bin/sh
CASSANDRA_IP={{ .Values.global.sdc_cassandra.serviceName }}.{{ include "common.namespace" . }}.svc.cluster.local
CASSANDRA_PASS="$CS_PASSWORD"
CASSANDRA_PORT={{ .Values.cassandraConfiguration.cassandraPort }}
echo "Changing Cassandra password..."

retry_num=1
is_up=0
while [ $is_up -eq 0 ] && [ $retry_num -le 100 ]; do
    echo "exit" | cqlsh -u cassandra -p cassandra $CASSANDRA_IP $CASSANDRA_PORT --cqlversion="{{ .Values.cassandraConfiguration.cql_version }}"
    res1=$?
    echo "exit" | cqlsh -u cassandra -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion="{{ .Values.cassandraConfiguration.cql_version }}"
    res2=$?

    if [ $res1 -eq 0 ] || [ $res2 -eq 0 ]; then
        echo "$(date) --- cqlsh is able to connect."
        is_up=1
    else
        echo "$(date) --- cqlsh is NOT able to connect yet. Sleeping for 5 seconds."
        sleep 5
    fi
    retry_num=$((retry_num + 1))
done

if [ $res1 -eq 0 ] && [ $res2 -eq 1 ] && [ $is_up -eq 1 ]; then
    echo "Modifying Cassandra password"
    echo "ALTER USER cassandra WITH PASSWORD '$CASSANDRA_PASS';" | cqlsh -u cassandra -p cassandra $CASSANDRA_IP $CASSANDRA_PORT --cqlversion="{{ .Values.cassandraConfiguration.cql_version }}"
elif [ $res1 -eq 1 ] && [ $res2 -eq 0 ] && [ $is_up -eq 1 ]; then
    echo "Cassandra password already modified"
else
    exit 1
fi
