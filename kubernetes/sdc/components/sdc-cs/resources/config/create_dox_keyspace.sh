#!/bin/sh
CASSANDRA_USER="$SDC_USER"
CASSANDRA_IP={{ .Values.global.sdc_cassandra.serviceName }}.{{ include "common.namespace" . }}.svc.cluster.local
CASSANDRA_PASS="$SDC_PASSWORD"
CASSANDRA_PORT={{ .Values.cassandraConfiguration.cassandraPort }}
DC_NAME={{ .Values.cassandraConfiguration.datacenterName }}
CASSANDRA_COMMAND="cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion={{ .Values.cassandraConfiguration.cql_version }}"

# Define Keyspace Creation Statements
KEYSPACE="CREATE KEYSPACE IF NOT EXISTS dox WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '$DC_NAME': '1'};"
KEYSPACE1="CREATE KEYSPACE IF NOT EXISTS zusammen_dox WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '$DC_NAME': '1'};"
KEYSPACE2="CREATE KEYSPACE IF NOT EXISTS sdctitan WITH REPLICATION = { 'class' : 'NetworkTopologyStrategy', '$DC_NAME': '3'} AND durable_writes = true;"

# Save Commands to File
echo "run create_dox_keyspace.cql"
echo "$KEYSPACE" > /tmp/config/create_dox_keyspace.cql
echo "$KEYSPACE1" >> /tmp/config/create_dox_keyspace.cql
echo "$KEYSPACE2" >> /tmp/config/create_dox_keyspace.cql

chmod 555 /tmp/config/create_dox_keyspace.cql

# Execute Keyspace Creation
$CASSANDRA_COMMAND -f /tmp/config/create_dox_keyspace.cql > /dev/null 2>&1

# Verify Keyspace Creation
res=$(echo "select keyspace_name from system_schema.keyspaces;" | cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion={{ .Values.cassandraConfiguration.cql_version }} | grep -c dox 2>/dev/null)

if [ $res -gt 0 ]; then
    echo "$(date) --- dox keyspace was created"
else
    echo "$(date) --- Failed to create dox keyspace"
fi

# Check sdctitan Keyspace Creation
res_sdctitan=$(echo "select keyspace_name from system_schema.keyspaces;" | cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion={{ .Values.cassandraConfiguration.cql_version }} | grep -c sdctitan 2>/dev/null)

if [ $res_sdctitan -gt 0 ]; then
    echo "$(date) --- sdctitan keyspace was created"
else
    echo "$(date) --- Failed to create sdctitan keyspace"
fi
