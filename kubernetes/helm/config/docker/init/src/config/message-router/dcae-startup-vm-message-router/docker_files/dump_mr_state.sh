#!/bin/bash


TIMESTAMP=`date +%Y%m%d%H%M`
CONTAINERID=`docker ps |grep kafka |cut -b1-12`
docker cp $CONTAINERID:/kafka ./data-kafka-$TIMESTAMP
tar zcvf ./data-kafka-$TIMESTAMP.tgz ./data-kafka-$TIMESTAMP
CONTAINERID=`docker ps |grep zookeeper |cut -b1-12`
docker cp $CONTAINERID:/opt/zookeeper-3.4.9/data ./data-zookeeper-$TIMESTAMP
tar zcvf ./data-zookeeper-$TIMESTAMP.tgz ./data-zookeeper-$TIMESTAMP
