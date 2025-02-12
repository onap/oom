#!/bin/sh
CASSANDRA_USER="$SDC_USER"
CASSANDRA_IP=cassandra-dc1-service.{{ include "common.namespace" . }}.svc.cluster.local
CASSANDRA_PASS="$SDC_PASSWORD"
CASSANDRA_PORT={{ .Values.cassandraConfiguration.cassandraPort }}
DC_NAME={{ .Values.cassandraConfiguration.datacenterName }}
CASSANDRA_COMMAND="cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion={{ .Values.cassandraConfiguration.cql_version }}"
KEYSPACE="CREATE KEYSPACE IF NOT EXISTS dox WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '$DC_NAME': '1'};"
KEYSPACE1="CREATE KEYSPACE IF NOT EXISTS zusammen_dox WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '$DC_NAME': '1'};"
echo "run create_dox_keyspace.cql"
echo "$KEYSPACE" > /tmp/config/create_dox_keyspace.cql
echo "$KEYSPACE1" >> /tmp/config/create_dox_keyspace.cql
chmod 555 /tmp/config/create_dox_keyspace.cql
$CASSANDRA_COMMAND -f /tmp/config/create_dox_keyspace.cql > /dev/null 2>&1
res=$(echo "select keyspace_name from system_schema.keyspaces;" | cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion={{ .Values.cassandraConfiguration.cql_version }} | grep -c dox 2>/dev/null)
if [ $res -gt 0 ]; then
    echo "$(date) --- dox keyspace was created"
else
    echo "$(date) --- Failed to create dox keyspace"
fi
