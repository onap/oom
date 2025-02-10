#!/bin/sh

# Variables

INTERNAL_PORT=8181
HEALTHCHECK_URL="http://localhost:8181/sdc1/rest/healthCheck"

# 1. TCP Socket Check for Internal Port

nc -z localhost $INTERNAL_PORT
TCP_STATUS=$?

if [ $TCP_STATUS -ne 0 ]; then
    echo "TCP check failed: Internal port $INTERNAL_PORT is not open."
    exit 1
fi

# 2. Cassandra Health Check from API Response using jq

CASSANDRA_STATUS=$(curl -s $HEALTHCHECK_URL | jq -r '.componentsInfo[] | select(.healthCheckComponent == "CASSANDRA") | .healthCheckStatus')

if [ "$CASSANDRA_STATUS" != "UP" ]; then
    echo "Cassandra API check failed: HealthCheck status is $CASSANDRA_STATUS, not UP."
    exit 1
fi

echo "Liveness check passed: Internal port $INTERNAL_PORT is open, and Cassandra is healthy."
exit 0
