#!/bin/sh

SEARCH_SERVICE_NAME="search-data-service.onap-aai"
SEARCH_SERVICE_PORT=9509
HEALTH_CHECK_INDEX="healthcheck"

# 'Document Index' REST Endpoint
INDEX_URL="https://$SEARCH_SERVICE_NAME:$SEARCH_SERVICE_PORT/services/search-data-service/v1/search/indexes/$HEALTH_CHECK_INDEX"
INDEX_SCHEMA="{\"fields\":[{\"name\": \"field1\", \"data-type\": \"string\"}]}"


SEARCH_CERT_FILE="/consul/config/client-cert-onap.crt.pem"
SEARCH_KEY_FILE="/consul/config/client-cert-onap.key.pem"


## Try to create an index via the Search Data Service API.
CREATE_INDEX_RESP=$(curl -s -o /dev/null -w "%{http_code}" -k --cert $SEARCH_CERT_FILE --cert-type PEM --key $SEARCH_KEY_FILE --key-type PEM -d "$INDEX_SCHEMA" --header "Content-Type: application/json" --header "X-TransactionId: ConsulHealthCheck" -X PUT $INDEX_URL) 

RESULT_STRING=" "

if [ $CREATE_INDEX_RESP -eq 201 ]; then
   RESULT_STRING="Service Is Able To Communicate With Back End"
elif [ $CREATE_INDEX_RESP -eq 400 ]; then
   # A 400 response could mean that the index already exists (ie: we didn't
   # clean up after ourselves on a previous check), so log the response but
   # don't exit yet.  If we fail on the delete then we can consider the
   # check a failure, otherwise, we are good.
   RESULT_STRING="$RESULT_STRING Create Index [FAIL - 400 (possible index already exists)] "
else
   RESULT_STRING="Service API Failure - $CREATE_INDEX_RESP"
   echo $RESULT_STRING
   exit 1
fi

## Now, clean up after ourselves.
DELETE_INDEX_RESP=$(curl -s -o /dev/null -w "%{http_code}" -k --cert $SEARCH_CERT_FILE --cert-type PEM --key $SEARCH_KEY_FILE --key-type PEM -d "{ }" --header "Content-Type: application/json" --header "X-TransactionId: ConsulHealthCheck" -X DELETE $INDEX_URL) 

if [ $DELETE_INDEX_RESP -eq 200 ]; then
   RESULT_STRING="Service Is Able To Communicate With Back End"
else 
   RESULT_STRING="Service API Failure - $DELETE_INDEX_RESP"
   echo $RESULT_STRING 
   exit 1
fi

echo $RESULT_STRING
return 0
