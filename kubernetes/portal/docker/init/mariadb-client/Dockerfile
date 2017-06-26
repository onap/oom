FROM ubuntu:16.04

ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy ${HTTP_PROXY}
ENV http_proxy ${HTTPS_PROXY}

RUN apt-get update
RUN apt-get install -y mariadb-client-10.0

VOLUME /portal-mysql
