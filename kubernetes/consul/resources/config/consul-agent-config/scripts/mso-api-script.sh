## Query the health check API.
HEALTH_CHECK_ENDPOINT="http://mso.onap-mso.svc.cluster.local:8080/ecomp/mso/infra/healthcheck"
HEALTH_CHECK_RESPONSE=$(curl -s $HEALTH_CHECK_ENDPOINT)

READY=$(echo $HEALTH_CHECK_RESPONSE | grep "Application ready")

if [ -n $READY ]; then
  echo "Query against health check endpoint: $HEALTH_CHECK_ENDPOINT"
  echo "Produces response: $HEALTH_CHECK_RESPONSE"
  echo "Application is not in an available state"
  return 2
else
  echo "Application is available."
  return 0
fi
