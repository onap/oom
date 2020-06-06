FROM python:3-alpine3.9

ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy ${HTTPS_PROXY}
ENV http_proxy ${HTTP_PROXY}

RUN pip install --no-cache-dir requests pyyaml kubernetes

ENV CERT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
ENV TOKEN="/var/run/secrets/kubernetes.io/serviceaccount/token"

COPY maven/ /root/
RUN chmod -R a+x /root/

ENTRYPOINT ["/root/ready.py"]
CMD [""]