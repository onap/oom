from ubuntu:16.04

ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy ${HTTPS_PROXY}
ENV http_proxy ${HTTP_PROXY}

# Additional packages
RUN apt-get update
RUN apt-get install -y openssl vim-common
RUN mkdir -p /opt/config/src/

# Instal kubectl commands
RUN apt -y install curl
RUN curl -LO https://storage.googleapis.com/kubernetes-release/release/$(curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt)/bin/linux/amd64/kubectl
RUN chmod +x ./kubectl
RUN mv ./kubectl /usr/local/bin/kubectl

COPY onap-cfg.tar.gz /tmp/
RUN tar -zxvf /tmp/onap-cfg.tar.gz -C /opt/config/src/
COPY config-init.sh /root/config-init.sh
RUN chmod a+x /root/config-init.sh
ENTRYPOINT /root/config-init.sh
