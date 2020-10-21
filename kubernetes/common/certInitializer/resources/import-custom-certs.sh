#!/bin/bash
{{/*

# Copyright © 2020 Bell Canada
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#       http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
*/}}

CERTS_DIR=${CERTS_DIR:-/certs}
WORK_DIR=${WORK_DIR:-/updatedTruststore}
ONAP_TRUSTSTORE=${ONAP_TRUSTSTORE:-truststoreONAPall.jks}
JRE_TRUSTSTORE=${JRE_TRUSTSTORE:-$JAVA_HOME/lib/security/cacerts}
TRUSTSTORE_OUTPUT_FILENAME=${TRUSTSTORE_OUTPUT_FILENAME:-truststore.jks}

mkdir -p $WORK_DIR

# Decrypt and move relevant files to WORK_DIR
for f in $CERTS_DIR/*; do
  if [[ $AAF_ENABLED == false ]] && [[ $f == *$ONAP_TRUSTSTORE* ]]; then
    # Dont use onap truststore when aaf is disabled
    continue
  fi
  if [[ $f == *.sh ]]; then
    continue
  fi
  if [[ $f == *.b64 ]]
    then
      base64 -d $f > $WORK_DIR/`basename $f .b64`
    else
      cp $f $WORK_DIR/.
  fi
done

# Prepare truststore output file
if [[ $AAF_ENABLED == true ]]
  then
    mv $WORK_DIR/$ONAP_TRUSTSTORE $WORK_DIR/$TRUSTSTORE_OUTPUT_FILENAME
  else
    echo "AAF is disabled, using JRE truststore"
    cp $JRE_TRUSTSTORE $WORK_DIR/$TRUSTSTORE_OUTPUT_FILENAME
fi

# Import Custom Certificates
for f in $WORK_DIR/*; do
  if [[ $f == *.pem ]]; then
    echo "importing certificate: $f"
    keytool -import -file $f -alias `basename $f` -keystore $WORK_DIR/$TRUSTSTORE_OUTPUT_FILENAME -storepass $TRUSTSTORE_PASSWORD -noprompt
    if [[ $? != 0 ]]; then
      echo "failed importing certificate: $f"
      exit 1
    fi
  fi
done
