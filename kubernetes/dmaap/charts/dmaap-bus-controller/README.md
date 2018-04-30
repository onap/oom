# Helm Chart for ONAP DMaaP Applications

ONAP includes the following Kubernetes services available in ONAP Beijing Release (more expected in future):

1) message-router - a message bus for applications
2) dmaap-prov - an API to provision DMaaP resources

# Service Dependencies

message-router depends on AAF
dmaap-prov depends on AAF and Postgresql.  
