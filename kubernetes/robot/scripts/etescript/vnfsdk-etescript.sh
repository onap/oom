#!/bin/sh

# SPDX-License-Identifier: Apache-2.0

#
# Create root certificate CA (Certificate Authority) and its private key.
# Create the package certificate issued by CA
# Copy the stuff to SDC ONBOARDING and Robot pods.
#



SDCVALID=sdc-valid
SDCINVALID=sdc-invalid
ROBOTPOD=$(kubectl -n $NAMESPACE get pods --no-headers=true -o custom-columns=:metadata.name | grep robot )
SDCONBOARDINGPOD=$(kubectl -n $NAMESPACE get pods --no-headers=true -o custom-columns=:metadata.name | grep sdc-onboarding-be | grep -v cassandra)

generate_ca_key_cert_and_package_cert_issued_by_CA () {
        openssl req -batch -new -nodes -x509 -days 36500 -keyout rootCA-private-robot-$1.key -out rootCA-robot-$1.cert
        openssl req -batch -new -nodes -keyout package-private-robot-$1.key -out package-robot-$1.csr
        openssl x509 -req -CA rootCA-robot-$1.cert -CAkey rootCA-private-robot-$1.key -CAcreateserial -in package-robot-$1.csr -out package-robot-$1.cert
}


copy_root_cert_to_sdc_onboarding () {
        kubectl cp $1/rootCA-robot-$5.cert $2/$3:$4
}

copy_package_certs_to_robot () {
        for f in package-robot-$5.cert package-private-robot-$5.key
        do
                kubectl cp $1/$f $2/$3:$4
        done
}

mkdir "$DIR/$SCRIPTDIR/tmp"
cd "$DIR/$SCRIPTDIR/tmp"
if [ -f rootCA-robot-$SDCVALID.cert ] && [ -f package-robot-$SDCVALID.cert ] && [ -f package-robot-$SDCINVALID.cert ] && [ -f package-private-robot-$SDCVALID.key ] && [ -f package-private-robot-$SDCINVALID.key ]; then
        echo "All files are present";
else
        generate_ca_key_cert_and_package_cert_issued_by_CA $SDCVALID
        generate_ca_key_cert_and_package_cert_issued_by_CA $SDCINVALID

fi
cd ../../..
copy_root_cert_to_sdc_onboarding "$DIR/$SCRIPTDIR/tmp" "$NAMESPACE" "$SDCONBOARDINGPOD" "/var/lib/jetty/cert" $SDCVALID
copy_package_certs_to_robot "$DIR/$SCRIPTDIR/tmp" "$NAMESPACE" "$ROBOTPOD" "/tmp" $SDCVALID
copy_package_certs_to_robot "$DIR/$SCRIPTDIR/tmp" "$NAMESPACE" "$ROBOTPOD" "/tmp" $SDCINVALID

