#!/bin/bash

HOSTPORT="127.0.0.1:3904"
KEYDIR="."


# dictionary of API Keys and the tpics owned by each API key
declare -A topics
topics=( \
["anonymous"]="APPC-CL APPC-TEST2 PDPD-CONFIGURATION POLICY-CL-MGT DCAE-CL-EVENT unauthenticated.SEC_MEASUREMENT_OUTPUT unauthenticated.TCA_EVENT_OUTPUT " \
["apikey-SDC1"]="SDC-DISTR-NOTIF-TOPIC-SDC-OPENSOURCE-ENV1 SDC-DISTR-STATUS-TOPIC-SDC-OPENSOURCE-ENV1" \
["apikey-APPC1"]="APPC-TEST1" \
["apikey-PORTAL1"]="ECOMP-PORTAL-INBOX" \
["apikey-PORTALAPP1"]="ECOMP-PORTAL-OUTBOX-APP1" \
["apikey-PORTALDBC1"]="ECOMP-PORTAL-OUTBOX-DBC1" \
["apikey-PORTALSDC1"]="ECOMP-PORTAL-OUTBOX-SDC1" \
["apikey-PORTALVID1"]="ECOMP-PORTAL-OUTBOX-VID1" \
["apikey-PORTALPOL1"]="ECOMP-PORTAL-OUTBOX-POL1" \
)

# dictionary of producers for each topic
declare -A acl_producers
acl_producers=(\
["SDC-DISTR-NOTIF-TOPIC-SDC-OPENSOURCE-ENV1"]="apikey-sdc1" \
["SDC-DISTR-STATUS-TOPIC-SDC-OPENSOURCE-ENV1"]="apikey-sdc1" \
["ECOMP-PORTAL-INBOX"]="apikey-PORTALAPP1 apikey-PORTALDBC1 apikey-PORTALSDC1 apikey-PORTALVID1 apikey-PORTALPOL1" \
["ECOMP-PORTAL-OUTBOX-APP1"]="apikey-PORTAL1" \
["ECOMP-PORTAL-OUTBOX-DBC1"]="apikey-PORTAL1" \
["ECOMP-PORTAL-OUTBOX-SDC1"]="apikey-PORTAL1" \
["ECOMP-PORTAL-OUTBOX-VID1"]="apikey-PORTAL1" \
["ECOMP-PORTAL-OUTBOX-POL1"]="apikey-PORTAL1" \
["APPC-TEST1"]="apikey-APPC1" \
)

# dictionary of consumers for each topic
declare -A acl_consumers
acl_consumers=(\
["SDC-DISTR-NOTIF-TOPIC-SDC-OPENSOURCE-ENV1"]="apikey-sdc1" \
["SDC-DISTR-STATUS-TOPIC-SDC-OPENSOURCE-ENV1"]="apikey-sdc1" \
["ECOMP-PORTAL-INBOX"]="apikey-PORTAL1" \
["ECOMP-PORTAL-OUTBOX-APP1"]="apikey-PORTALAPP1" \
["ECOMP-PORTAL-OUTBOX-DBC1"]="apikey-PORTALDBC1" \
["ECOMP-PORTAL-OUTBOX-SDC1"]="apikey-PORTALSDC1" \
["ECOMP-PORTAL-OUTBOX-VID1"]="apikey-PORTALVID1" \
["ECOMP-PORTAL-OUTBOX-POL1"]="apikey-PORTALPOL1" \
["APPC-TEST1"]="apikey-APPC1" \
)

myrun () {
    CMD="$1"
    echo "CMD:[$CMD]"
    eval $CMD
}

getowner () {
    local -n outowner=$2
    target_topic="$1"
    echo "look for owner for $target_topic"
    for o in "${!topics[@]}"; do 
        keytopics=${topics[$o]}
        for topic in ${keytopics}; do
            if [ "$topic" == "-" ]; then
                continue
            fi
            if [ "$topic" == "$target_topic" ]; then
                echo "found owner $o"
                outowner=$o
                return
            fi
        done
    done
}

add_acl () {
    acl_group="$1"
    topic="$2"
    client="$3"
    echo " adding $client to group $acl_group for topic $2"

    getowner "$topic" owner
    echo "==owner for $topic is $owner"


    if [ -z "$owner" ]; then
        echo "No owner API key found for topic $topic"
        #exit
    fi
    OWNER_API_KEYFILE="${KEYDIR}/${owner}.key"
    if [ ! -e $API_KEYFILE ]; then
        echo "No API key file $OWNER_API_KEYFILE for owner $owner of topic $topic, exit "
        #exit
    fi 

    CLIENT_API_KEYFILE="${KEYDIR}/${client}.key"
    if [ ! -e $CLIENT_API_KEYFILE ]; then
        echo "No API key file $CLIENT_API_KEYFILE for client $client, exit "
        #exit
    else
        CLIENTKEY=`cat ${CLIENT_API_KEYFILE} |jq -r ".key"`
        UEBAPIKEYSECRET=`cat ${OWNER_API_KEYFILE} |jq -r ".secret"`
        UEBAPIKEYKEY=`cat ${OWNER_API_KEYFILE} |jq -r ".key"`
        time=`date --iso-8601=seconds`
        signature=$(echo -n "$time" | openssl sha1 -hmac $UEBAPIKEYSECRET -binary | openssl base64)
        xAuth=$UEBAPIKEYKEY:$signature
        xDate="$time"
        CMD="curl -i -H \"Content-Type: application/json\"  -H \"X-CambriaAuth:$xAuth\"  -H \"X-CambriaDate:$xDate\" -X PUT http://${HOSTPORT}/topics/${topic}/${acl_group}/${CLIENTKEY}"
        myrun "$CMD"
    fi
}


for key in "${!topics[@]}"; do 
    # try to create key if no such key exists
    API_KEYFILE="${KEYDIR}/${key}.key"
    if [ "$key" != "anonymous" ]; then
        if [ -e ${API_KEYFILE} ]; then
            echo "API key for $key already exists, no need to create new"
        else
            echo "generating API key $key"
            echo '{"email":"no email","description":"API key for '$key'"}' > /tmp/input.txt

            CMD="curl -s -o ${API_KEYFILE} -H \"Content-Type: application/json\" -X POST -d @/tmp/input.txt http://${HOSTPORT}/apiKeys/create"
            myrun "$CMD"
            echo "API key for $key has been created: "; cat ${API_KEYFILE}
            echo "generating API key $key done"; echo
        fi
    fi

    # create the topics for this key
    keytopics=${topics[$key]}
    for topic in ${keytopics}; do
        if [ "$topic" == "-" ]; then
            continue
        fi
        if [ "$key" == "anonymous" ]; then
            echo "creating anonymous topic $topic"
            CMD="curl  -H \"Content-Type:text/plain\" -X POST -d @/tmp/sample.txt http://${HOSTPORT}/events/${topic}"
            myrun "$CMD"
            echo "done creating anonymous topic $topic"; echo
        else
            echo "creating API key secured topic $topic for API key $key"
            UEBAPIKEYSECRET=`cat ${API_KEYFILE} |jq -r ".secret"`
            UEBAPIKEYKEY=`cat ${API_KEYFILE} |jq -r ".key"`
            echo '{"topicName":"'${topic}'","topicDescription":"'$key' API Key secure topic","partitionCount":"1","replicationCount":"1","transactionEnabled":"true"}' > /tmp/topicname.txt
            time=`date --iso-8601=seconds`
            signature=$(echo -n "$time" | openssl sha1 -hmac $UEBAPIKEYSECRET -binary | openssl base64)
            xAuth=$UEBAPIKEYKEY:$signature
            xDate="$time"
            CMD="curl -i -H \"Content-Type: application/json\"  -H \"X-CambriaAuth: $xAuth\"  -H \"X-CambriaDate: $xDate\" -X POST -d @/tmp/topicname.txt http://${HOSTPORT}/topics/create"
            myrun "$CMD"
            echo "done creating api key topic $topic"
            echo
        fi
    done
done


echo 
echo "============ post loading state of topics ================="
CMD="curl http://${HOSTPORT}/topics"
myrun "$CMD"
for key in "${!topics[@]}"; do 
    keytopics=${topics[$key]}
    echo "---------- key: ${key} "
    for topic in ${keytopics}; do
        if [ "$topic" == "-" ]; then
            continue
        fi
        CMD="curl http://${HOSTPORT}/topics/${topic}"
        myrun "$CMD"
        echo
    done
    echo "end of key: ${key} secured topics"
done


# adding publisher and subscriber ACL 
for topic in "${!acl_consumers[@]}"; do 
    consumers=${acl_consumers[$topic]}
    for consumer in ${consumers}; do
        add_acl "consumers" "$topic" "$consumer"
    done
done

for topic in "${!acl_producers[@]}"; do 
    producers=${acl_producers[$topic]}
    for producer in ${producers}; do
        add_acl "producers" "$topic" "$producer"
    done
done

