# Helm Chart for ONAP DMaaP Applications

ONAP includes the following Kubernetes services:

1) message-router - a message bus for applications
2) dbc-api - an API to provision DMaaP resources

# Service Dependencies

message-router depends on AAF
dbc-api depends on AAF and Postgresql.  
