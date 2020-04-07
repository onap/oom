#!/bin/bash

waitForEjbcaToStart() {
    until $(curl -kI https://localhost:8443/ejbca/publicweb/healthcheck/ejbcahealth --output /dev/null --silent --head --fail)
    do
        sleep 5
    done
}

configureEjbca() {
    ejbca.sh config cmp addalias --alias cmpRA
    ejbca.sh config cmp updatealias --alias cmpRA --key operationmode --value ra
    ejbca.sh ca editca --caname ManagementCA --field cmpRaAuthSecret --value ${RA_IAK}
    ejbca.sh config cmp updatealias --alias cmpRA --key responseprotection --value pbe
    ejbca.sh config cmp dumpalias --alias cmpRA
    ejbca.sh config cmp addalias --alias cmp
    ejbca.sh config cmp updatealias --alias cmp --key allowautomatickeyupdate --value true
    ejbca.sh config cmp updatealias --alias cmp --key responseprotection --value pbe
    ejbca.sh ra addendentity --username Node123 --dn "CN=Node123" --caname ManagementCA --password ${CLIENT_IAK} --type 1 --token USERGENERATED
    ejbca.sh ra setclearpwd --username Node123 --password ${CLIENT_IAK}
    ejbca.sh config cmp updatealias --alias cmp --key extractusernamecomponent --value CN
    ejbca.sh config cmp dumpalias --alias cmp
    ejbca.sh ca getcacert --caname ManagementCA -f /dev/stdout > cacert.pem
}


waitForEjbcaToStart
configureEjbca
