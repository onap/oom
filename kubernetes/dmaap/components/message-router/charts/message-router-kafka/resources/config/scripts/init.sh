#!/bin/bash
set -e
set -x

advertisedListener=

usage(){
	echo "-al --advertised-listener : kafka advertised listener"
	exit 1
}
while [[ "$1" != "" ]]; do
    case $1 in
        -al | --advertised-listener )    shift
                                advertisedListener=$1
                                ;;
        -h | --help )           usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done



cp /etc/kafka-configmap/files/log4j.properties /etc/kafka/
cp /etc/kafka-configmap/files/server.properties /etc/kafka/

KAFKA_BROKER_ID=${HOSTNAME##*-}
SEDS=("s|#init#broker.id=#init#|broker.id=$KAFKA_BROKER_ID|")
SEDS+=("s|#init#advertised.listeners=#init#|advertised.listeners=${advertisedListener}|")

printf '%s\n' "${SEDS[@]}" | sed -f - /etc/kafka/server.properties > /etc/kafka/server.properties.tmp
[[ $? -eq 0 ]] && mv /etc/kafka/server.properties.tmp /etc/kafka/server.properties
