# Helm Chart for ONAP DMaaP Applications

ONAP includes the following Kubernetes services:

1) message-router - a message bus for applications
2) dmaap-prov - an API to provision DMaaP resources

# Service Dependencies

message-router depends on AAF
dmaap-prov depends on AAF and Postgresql.  NOTE: until Postgresql is available as a common service in ONAP, this chart deploys a private instance based on kubernetes/stable chart
