FROM ubuntu:16.04

ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy http://genproxy.amdocs.com:8080/
ENV http_proxy http://genproxy.amdocs.com:8080/

RUN apt-get update
RUN apt-get install -y mariadb-client-10.0

VOLUME /portal-mysql
