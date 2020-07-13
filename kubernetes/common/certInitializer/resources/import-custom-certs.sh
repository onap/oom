#!/bin/bash

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

CERTS_DIR=${CERTS_DIR:-/certs}
WORK_DIR=${WORK_DIR:-/updatedTruststore}
TRUSTSTORE=${TRUSTSTORE:-truststoreONAPall.jks}

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
    keytool -import -file $f -alias `basename $f` -keystore $WORK_DIR/$TRUSTSTORE -storepass $TRUSTSTORE_PASSWORD -noprompt
    if [[ $? != 0 ]]; then
      echo "failed importing certificate: $f"
      exit 1
    fi
  fi
done
