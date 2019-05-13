FROM python:2-alpine

ENV no_proxy "localhost,127.0.0.1,.cluster.local,$KUBERNETES_SERVICE_HOST"
# Setup Corporate proxy
ENV https_proxy ${HTTPS_PROXY}
ENV http_proxy ${HTTP_PROXY}

RUN pip install requests pyyaml kubernetes

ENV CERT="/var/run/secrets/kubernetes.io/serviceaccount/ca.crt"
ENV TOKEN="/var/run/secrets/kubernetes.io/serviceaccount/token"

COPY ready.py /root/ready.py
RUN chmod a+x /root/ready.py

COPY job_complete.py /root/job_complete.py
RUN chmod a+x /root/job_complete.py

ENTRYPOINT ["/root/ready.py"]
CMD [""]