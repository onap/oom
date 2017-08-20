#!/bin/ksh
#
# depends on jq - https://stedolan.github.io/jq/ 

PROTOCOL=http
FQDN=127.0.0.1
#vm1-message-router
#FQDN=10.208.128.229
PORT=3904
URL=$PROTOCOL://$FQDN:$PORT

rm -f out/*
mkdir -p out

results() {
#	echo "[debug] compare $1 to $2"
	if [ $1 == $2 ]
	then
		echo -n "SUCCESS    "
	else
		echo -n "FAIL ($1) "
	fi
	echo " :TEST $3 ($4)"
}
SUITE=0
SUITE=$((SUITE + 1))
echo "SUITE $SUITE: List topics"
TN=0
TN=$((TN + 1))
TC=$SUITE.$TN
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out $URL/topics`
results $rc $expect $TC "list"
StartTopicCount=`cat out/$TC.out | wc -l`


SUITE=$((SUITE + 1))
echo
echo "SUITE $SUITE: APIKEY authenticated topic"
TOPIC=Topic-$$-$SUITE
TN=0
TN=$((TN + 1))
TC=$SUITE.$TN
OUT=out/$TC.out
echo '{ "email": "no.email", "description": "request for direct response KEY" }' > key.req
rc=`curl -s -w "%{http_code}" -o out/$TC.out -X POST -H "Content-Type: application/json" -d @key.req $URL/apiKeys/create`
results $rc $expect $SUITE.$TN "gen apikey " 
TN=$((TN + 1))
TC=$SUITE.$TN
SECRET=$(jq ".secret" $OUT | cut -f 2 -d \")
KEY=$(jq ".key" $OUT | cut -f 2 -d \")
TIME=`date --iso-8601=seconds`
SIG=$(echo -n "$TIME" | openssl sha1 -hmac $SECRET -binary | openssl base64)
xAUTH=$KEY:$SIG
#echo "[debug] $SECRET  $KEY  $TIME $SIG $xAUTH"
DATA=data.$TC.json
echo "{ \"topicName\": \"$TOPIC\", \"topicDescription\": \"topic for test $TC\", \"partitionCount\": \"1\", \"replicationCount\": \"1\", \"transactionEnabled\": \"true\" }" > $DATA
rc=`curl -s -w "%{http_code}" -o out/$TC.out -X POST -H "Content-Type: application/json" -H "X-CambriaAuth: $xAUTH" -H "X-CambriaDate: $TIME" -d @$DATA $URL/topics/create`
results $rc $expect $SUITE.$TN "create topic" 
TN=$((TN + 1))
TC=$SUITE.$TN
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out $URL/topics`
results $rc $expect $TC "list "
TopicCnt=`cat out/$TC.out | wc -l`
results $TopicCnt $((StartTopicCount + 1)) $TC "topic count"
TN=$((TN + 1))
TC=$SUITE.$TN
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out $URL/topics/$TOPIC`
results $rc $expect $TC "list $TOPIC"
TN=$((TN + 1))
TC=$SUITE.$TN
DATA=data.$TC.json
echo "{ \"datestamp\": \"`date`\", \"appkey\": \"x100\", \"appval\": \"some value\" }" > $DATA
rc=`curl -s -w "%{http_code}" -o out/$TC.out -X POST -H "Content-Type: application/json" -H "X-CambriaAuth: $xAUTH" -H "X-CambriaDate: $TIME" -d @$DATA $URL/events/$TOPIC`
results $rc $expect $SUITE.$TN "pub APIKEY topic" 
TN=$((TN + 1))
TC=$SUITE.$TN
rc=`curl -s -w "%{http_code}" -o out/$TC.out -X GET -H "Content-Type: application/json" -H "X-CambriaAuth: $xAUTH" -H "X-CambriaDate: $TIME" $URL/events/$TOPIC/g0/u1`
results $rc $expect $SUITE.$TN "sub APIKEY topic" 


SUITE=$((SUITE + 1))
echo
echo "SUITE $SUITE: anonymous topic"
TOPIC=$$.$SUITE
TN=0
TN=$((TN + 1))
TC=$SUITE.$TN
DATA=data.$TC.txt
echo "datestamp: `date`, key: $TC, value: this is a test " > $DATA
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out -X POST -H "Content-Type: text/plain" -d @$DATA $URL/events/$TOPIC`
results $rc $expect $SUITE.$TN "pub text/plain" 
TN=$((TN + 1))
TC=$SUITE.$TN
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out $URL/events/$TOPIC/group1/u$$?timeout=1000`
results $rc $expect $SUITE.$TN "sub text/plain" 
TN=$((TN + 1))
TC=$SUITE.$TN
DATA=data.$TC.json
echo "{ \"datestamp\": \"`date`\", \"key\": \"$TC\", \"value\": \"this is a test\" }" > $DATA
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out -X POST -H "Content-Type: application/json" -d @$DATA $URL/events/$TOPIC`
results $rc $expect $SUITE.$TN "pub json" 
TN=$((TN + 1))
TC=$SUITE.$TN
expect=200
rc=`curl -s -w "%{http_code}" -o out/$TC.out $URL/events/$TOPIC/group1/u$$?timeout=1000`
results $rc $expect $SUITE.$TN "sub json" 

