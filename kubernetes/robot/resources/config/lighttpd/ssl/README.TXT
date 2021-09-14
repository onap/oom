The following self-signed certificates were created for testing only.
You can replace them with your own if appropriate using this process or official certificates using what ever process is appropriate.


# create key and csr
openssl req -new -newkey rsa:2048 -nodes -keyout onap-robot.onap.key -out onap-robot.onap.csr

# sign csr
# 10 year self signed certificate
openssl x509 -req -days 3650 -in onap-robot.onap.csr -signkey onap-robot.onap.key -out onap-robot.onap.crt

# create PEM for lighttpd server
cat onap-robot.onap.key  onap-robot.onap.crt > onap-robot.onap.pem
