from ubuntu:16.04

ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy ${HTTPS_PROXY}
ENV http_proxy ${HTTP_PROXY}

# Additional packages
RUN apt-get update
RUN apt-get install -y apt-utils git wget curl dnsutils python python-pip jq net-tools coreutils vim

RUN pip install requests pyyaml kubernetes==1.0.2


ENV CERT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
ENV TOKEN="/var/run/secrets/kubernetes.io/serviceaccount/token"

COPY ready.py /root/ready.py
RUN chmod a+x /root/ready.py
#ENTRYPOINT /root/ready.py

