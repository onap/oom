FROM ubuntu:14.04

MAINTAINER dcae@lists.openecomp.org

WORKDIR /opt/app/manager

ENV HOME /opt/app/VESCollector
ENV JAVA_HOME /usr/lib/jvm/java-1.7.0-openjdk-amd64
ENV WORKDIR /opt/app/manager 

RUN apt-get update && apt-get install -y \
        bc \
        curl \
        telnet \
        vim \
        netcat \
	unzip \
        openjdk-7-jdk

COPY ./docker-resources/start-manager.sh /opt/app/manager
RUN chmod +x /opt/app/manager/start-manager.sh
RUN mkdir /opt/app/manager/logs
RUN mkdir /opt/app/manager/config
COPY ./docker-resources/config/ /opt/app/manager/config

#If docker container is being built with local zip file
#COPY ./docker-resources/dcae-controller-service-standardeventcollector-manager-1.1.0-SNAPSHOT-runtime.zip /tmp
ADD https://nexus.onap.org/content/repositories/staging/org/openecomp/dcae/controller/dcae-controller-service-standardeventcollector-manager/1.0.0/dcae-controller-service-standardeventcollector-manager-1.0.0-runtime.zip /tmp
COPY VESCollector-1.1.0-SNAPSHOT-bundle.tar.gz /tmp

RUN mkdir /tmp/dcae-controller-manager
RUN mkdir /tmp/VESCollector
RUN mkdir /opt/app/SEC

RUN unzip /tmp/dcae-controller-service-standardeventcollector-manager-1.0.0-runtime.zip -d /tmp/dcae-controller-manager
RUN tar -xzvf /tmp/VESCollector-1.1.0-SNAPSHOT-bundle.tar.gz -C /tmp/VESCollector

RUN mv /tmp/dcae-controller-manager/* /opt/app/manager
RUN mv /tmp/VESCollector/VESCollector-1.1.0-SNAPSHOT/* /opt/app/SEC

EXPOSE 9999

