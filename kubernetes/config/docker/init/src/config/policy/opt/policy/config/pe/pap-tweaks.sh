#! /bin/bash

# config directory may contain an ip_addr.txt file that specifies
# the VM IP address.  Substitute this value in the URL in the
# config.json file, overriding the hostname that came from the
# REST_PAPURL_WITH_AUTH_PASSWORD property in console.conf. This is
# to avoid hardcoding an IP address in console.conf that can change
# from one VM instance to the next.

if [[ -f config/ip_addr.txt ]]; then
	vm_ip=$(<config/ip_addr.txt)
	echo "Substituting VM IP address $vm_ip in console config.json file"
	sed -i -e "s@http:.*:@http://$vm_ip:@" \
	  $POLICY_HOME/servers/console/webapps/ecomp/app/policyApp/Properties/config.json
fi
