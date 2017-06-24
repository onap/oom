from ubuntu:16.04

RUN mkdir -p /opt/config/src/
VOLUME /config-init/

COPY onap-cfg.tar.gz /tmp/
RUN tar -zxvf /tmp/onap-cfg.tar.gz -C /opt/config/src/
COPY config-init.sh /root/config-init.sh
RUN chmod a+x /root/config-init.sh
ENTRYPOINT /root/config-init.sh
