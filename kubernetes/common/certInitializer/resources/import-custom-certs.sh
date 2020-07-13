#!/bin/bash
CERTS_DIR=${CERTS_DIR:-/certs}
WORK_DIR=${WORK_DIR:-/updatedTruststore}
TRUSTSTORE=${TRUSTSTORE:-truststoreONAPall.jks}
PASSWORD=${TRUSTSTORE_PASSWORD:-changeit}

mkdir -p $WORK_DIR

for f in $CERTS_DIR/*; do
  if [[ $f == *.b64 ]]
    then
      base64 -d $f > $WORK_DIR/`basename $f .b64`
    else
      cp $f $WORK_DIR/.
  fi
done

for f in $WORK_DIR/*; do
  if [[ $f == *.pem ]]; then
    echo "importing certificate: $f"
    keytool -import -file $f -alias `basename $f` -keystore $WORK_DIR/$TRUSTSTORE -storepass $PASSWORD -noprompt
    if [[ $? != 0 ]]; then
      echo "failed importing certificate: $f"
      exit 1
    fi
  fi
done
