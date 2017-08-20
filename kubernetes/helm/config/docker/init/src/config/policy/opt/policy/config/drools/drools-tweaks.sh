#! /bin/bash

# changes for health check
options enable policy-healthcheck
sedArgs=("-i")
while read var value ; do
	if [[ "${var}" == "" ]] ; then
		continue
	fi
	sedArgs+=("-e" "s@\${{${var}}}@${value}@g")
done <<-EOF
	PAP_HOST		pap
	PAP_USERNAME	testpap
	PAP_PASSWORD	alpha123
	PDP_HOST		pdp
	PDP_USERNAME	testpdp
	PDP_PASSWORD	alpha123
EOF

# convert file
sed "${sedArgs[@]}" ${POLICY_HOME}/config/*health*

cat >>${POLICY_HOME}/config/*health* <<-'EOF'
	http.server.services.HEALTHCHECK.userName=healthcheck
	http.server.services.HEALTHCHECK.password=zb!XztG34
EOF

sed -i -e 's/DCAE-CL-EVENT/unauthenticated.TCA_EVENT_OUTPUT/' \
       -e '/TCA_EVENT_OUTPUT\.servers/s/servers=.*$/servers=10.0.4.102/' \
    $POLICY_HOME/config/v*-controller.properties
