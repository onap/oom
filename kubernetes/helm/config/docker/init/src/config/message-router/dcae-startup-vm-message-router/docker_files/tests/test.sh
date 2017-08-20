#!/bin/bash
# lji: this is basically what Dom has in his regtest. re-do it in bash instead of ksh

HOSTPORT="127.0.0.1:3904"
ANONTOPIC="anon-topic-$RANDOM"
APITOPIC="api-topic-$RANDOM"
APIKEYFILE="/tmp/key"

echo "blah" > /tmp/sample.txt

if [ ! -e /usr/bin/jq ]; then
  apt-get update && apt-get -y install jq
fi


# list topics
curl http://${HOSTPORT}/topics

# publish to an anonymous topic (first publish creats the topic)
curl  -H "Content-Type:text/plain" -X POST -d @/tmp/sample.txt http://${HOSTPORT}/events/$ANONTOPIC

# subscribe to an anonymous topic
curl  -H "Content-Type:text/plain" -X GET http://${HOSTPORT}/events/$ANONTOPIC/group1/C1?timeout=5000 &
curl  -H "Content-Type:text/plain" -X POST -d @/tmp/sample.txt http://${HOSTPORT}/events/$ANONTOPIC




# create api key
echo '{"email":"no email","description":"API key and secret both in reponse"}' > /tmp/input.txt
curl -s -o ${APIKEYFILE}  -H "Content-Type:application/json" -X POST -d @/tmp/input.txt http://${HOSTPORT}/apiKeys/create 
UEBAPIKEYSECRET=`cat ${APIKEYFILE}  |jq -r ".secret"`
UEBAPIKEYKEY=`cat ${APIKEYFILE}  |jq -r ".key"`

# create an api key secured topic
# pay attendtion to replication count
echo '{"topicName":"'${APITOPIC}'","topicDescription":"This is an API key securedTopic","partitionCount":"1","replicationCount":"1","transactionEnabled":"true"}' > /tmp/topicname.txt
time=`date --iso-8601=seconds`
signature=$(echo -n "$time" | openssl sha1 -hmac $UEBAPIKEYSECRET -binary | openssl base64)
xAuth=$UEBAPIKEYKEY:$signature
xDate="$time"
curl -i -H "Content-Type: application/json"  -H "X-CambriaAuth:$xAuth"  -H "X-CambriaDate:$xDate" -X POST -d @/tmp/topicname.txt http://${HOSTPORT}/topics/create

# first subscribe and run it in bg.  then publish.  
time=`date --iso-8601=seconds`
signature=$(echo -n "$time" | openssl sha1 -hmac $UEBAPIKEYSECRET -binary | openssl base64)
xAuth=$UEBAPIKEYKEY:$signature
xDate="$time"
curl -H "X-CambriaAuth:$xAuth"  -H "X-CambriaDate:$xDate" -X GET http://${HOSTPORT}/events/${APITOPIC}/g0/u1 &
curl -H "Content-Type:text/plain"  -H "X-CambriaAuth:$xAuth"  -H "X-CambriaDate:$xDate" -X POST -d @/tmp/sample.txt http://${HOSTPORT}/events/${APITOPIC}
