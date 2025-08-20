#!/bin/sh
CASSANDRA_IP={{ .Values.global.sdc_cassandra.serviceName }}.{{ include "common.namespace" . }}.svc.cluster.local
CASSANDRA_PASS="$SDC_PASSWORD"
CASSANDRA_PORT={{ .Values.cassandraConfiguration.cassandraPort }}
CASSANDRA_USER="$SDC_USER"

CASSANDRA_COMMAND="cqlsh -u $CASSANDRA_USER -p $CASSANDRA_PASS $CASSANDRA_IP $CASSANDRA_PORT --cqlversion={{ .Values.cassandraConfiguration.cql_version }}"

echo "Running create_dox_db.cql"
chmod 755 /tmp/writable-config/tools/build/scripts/create_dox_db.cql
$CASSANDRA_COMMAND -f /tmp/writable-config/tools/build/scripts/create_dox_db.cql > /dev/null 2>&1

sleep 10

echo "Running alter_dox_db.cql"
chmod 755 /tmp/writable-config/tools/build/scripts/alter_dox_db.cql
$CASSANDRA_COMMAND -f /tmp/writable-config/tools/build/scripts/alter_dox_db.cql > /dev/null 2>&1
