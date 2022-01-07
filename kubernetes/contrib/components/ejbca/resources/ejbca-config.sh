#!/bin/sh

waitForEjbcaToStart() {
    until $(curl -kI https://localhost:8443/ejbca/publicweb/healthcheck/ejbcahealth --output /dev/null --silent --head --fail)
    do
        sleep 5
    done
}

configureEjbca() {
    ejbca.sh ca init \
      --caname ManagementCA \
      --dn "O=EJBCA Container Quickstart,CN=ManagementCA,UID=12345" \
      --tokenType soft \
      --keyspec 3072 \
      --keytype RSA \
      -v 3652 \
      --policy null \
      -s SHA256WithRSA \
      -type "x509"
    ejbca.sh config cmp addalias --alias cmpRA
    ejbca.sh config cmp updatealias --alias cmpRA --key operationmode --value ra
    ejbca.sh ca editca --caname ManagementCA --field cmpRaAuthSecret --value ${RA_IAK}
    ejbca.sh config cmp updatealias --alias cmpRA --key responseprotection --value signature
    ejbca.sh config cmp updatealias --alias cmpRA --key authenticationmodule --value 'HMAC;EndEntityCertificate'
    ejbca.sh config cmp updatealias --alias cmpRA --key authenticationparameters --value '-;ManagementCA'
    ejbca.sh config cmp updatealias --alias cmpRA --key allowautomatickeyupdate --value true
    #Custom EJBCA cert profile and endentity are imported to allow issuing certificates with correct extended usage (containing serverAuth)
    ejbca.sh ca importprofiles -d /opt/primekey/custom_profiles
    #Profile name taken from certprofile filename (certprofile_<profile-name>-<id>.xml)
    ejbca.sh config cmp updatealias --alias cmpRA --key ra.certificateprofile --value CUSTOM_ENDUSER
    #ID taken from entityprofile filename (entityprofile_<profile-name>-<id>.xml)
    ejbca.sh config cmp updatealias --alias cmpRA --key ra.endentityprofileid --value 1356531849
    caSubject=$(ejbca.sh ca getcacert --caname ManagementCA -f /dev/stdout | grep 'Subject' | sed -e "s/^Subject: //" | sed -n '1p')
    ejbca.sh config cmp updatealias --alias cmpRA --key defaultca --value "$caSubject"
    ejbca.sh config cmp dumpalias --alias cmpRA
    ejbca.sh config cmp addalias --alias cmp
    ejbca.sh config cmp updatealias --alias cmp --key allowautomatickeyupdate --value true
    ejbca.sh config cmp updatealias --alias cmp --key responseprotection --value pbe
    ejbca.sh ra addendentity --username Node123 --dn "CN=Node123" --caname ManagementCA --password ${CLIENT_IAK} --type 1 --token USERGENERATED
    ejbca.sh ra setclearpwd --username Node123 --password ${CLIENT_IAK}
    ejbca.sh config cmp updatealias --alias cmp --key extractusernamecomponent --value CN
    ejbca.sh config cmp dumpalias --alias cmp
    ejbca.sh ca getcacert --caname ManagementCA -f /dev/stdout > cacert.pem
    #Add "Certificate Update Admin" role to allow performing KUR/CR for certs within specific organization (e.g. Linux-Foundation)
    ejbca.sh roles addrole "Certificate Update Admin"
    ejbca.sh roles changerule "Certificate Update Admin" /ca/ManagementCA/ ACCEPT
    ejbca.sh roles changerule "Certificate Update Admin" /ca_functionality/create_certificate/ ACCEPT
    ejbca.sh roles changerule "Certificate Update Admin" /endentityprofilesrules/Custom_EndEntity/ ACCEPT
    ejbca.sh roles changerule "Certificate Update Admin" /ra_functionality/edit_end_entity/ ACCEPT
    ejbca.sh roles addrolemember "Certificate Update Admin" ManagementCA WITH_ORGANIZATION --value "{{ .Values.cmpv2Config.global.certificate.default.subject.organization }}"
    # workarround to exit successfully, as a reexecution of "addrolemember" returns an error
    exit 0
}


waitForEjbcaToStart
configureEjbca
