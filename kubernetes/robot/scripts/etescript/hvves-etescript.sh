#!/bin/sh

# Copyright © 2019 Nokia
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

#
# Generate HV-VES SSL related certs.
# Copy the stuff to HV-VES and Robot pods.
#


HVVESPOD=$(kubectl -n $NAMESPACE get pods --no-headers=true -o custom-columns=:metadata.name | grep hv-ves)


generate_ca_key_cert () {
    openssl genrsa -out $1/ca.key 2048
    openssl req -new -x509 -days 36500 -key $1/ca.key -out $1/ca.pem -subj /CN=dcae-hv-ves-ca.onap
}

generate_server_key_csr () {
    openssl genrsa -out $1/server.key 2048
    openssl req -new -key $1/server.key -out $1/server.csr -subj /CN=dcae-hv-ves-collector.onap
}

generate_client_key_csr () {
    openssl genrsa -out $1/client.key 2048
    openssl req -new -key $1/client.key -out $1/client.csr -subj /CN=dcae-hv-ves-client.onap
}

sign_server_and_client_cert () {
    openssl x509 -req -days 36500 -in $1/server.csr -CA $1/ca.pem -CAkey $1/ca.key -out $1/server.pem -set_serial 00
    openssl x509 -req -days 36500 -in $1/client.csr -CA $1/ca.pem -CAkey $1/ca.key -out $1/client.pem -set_serial 00
}

create_pkcs12_ca_and_server () {
    openssl pkcs12 -export -out $1/ca.p12 -inkey $1/ca.key -in $1/ca.pem -passout pass:
    openssl pkcs12 -export -out $1/server.p12 -inkey $1/server.key -in $1/server.pem -passout pass:
}

copy_server_certs_to_hvves () {
    for f in ca.p12 server.p12
    do
        kubectl cp $1/$f $2/$3:$4
    done
}

copy_client_certs_to_robot () {
    for f in ca.pem client.key client.pem
    do
                kubectl cp $1/$f $2/$3:$4
        done
}

cleanup () {
    rm -f $1/ca.??? $1/server.??? s$1/client.???
}


generate_ca_key_cert "$DIR/$SCRIPTDIR"
generate_server_key_csr "$DIR/$SCRIPTDIR"
generate_client_key_csr "$DIR/$SCRIPTDIR"
sign_server_and_client_cert "$DIR/$SCRIPTDIR"
create_pkcs12_ca_and_server "$DIR/$SCRIPTDIR"
copy_server_certs_to_hvves "$DIR/$SCRIPTDIR" "$NAMESPACE" "$HVVESPOD" "/tmp"
copy_client_certs_to_robot "$DIR/$SCRIPTDIR" "$NAMESPACE" "$POD" "/tmp"
cleanup "$DIR/$SCRIPTDIR"
