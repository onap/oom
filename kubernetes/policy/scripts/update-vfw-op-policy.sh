#!/bin/bash

if [ "$#" -ne 4 ]; then
	echo "Usage: $(basename $0) <k8s-host> <policy-pdp-node-port> <policy-drools-node-port> <resource-id>"
	exit 1
fi

K8S_HOST=$1
POLICY_PDP_PORT=$2
POLICY_DROOLS_PORT=$3
RESOURCE_ID=$4

echo
echo "Updating vFW Operational Policy .."
echo

curl -v -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "policyConfigType": "BRMS_PARAM",
  "policyName": "com.BRMSParamvFirewall",
  "policyDescription": "BRMS Param vFirewall policy",
  "policyScope": "com",
  "attributes": {
    "MATCHING": {
      "controller": "amsterdam"
    },
    "RULE": {
      "templateName": "ClosedLoopControlName",
      "closedLoopControlName": "ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a",
      "controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+2.0.0%0D%0A++controlLoopName%3A+ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a%0D%0A++trigger_policy%3A+unique-policy-id-1-modifyConfig%0D%0A++timeout%3A+1200%0D%0A++abatement%3A+false%0D%0A+%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-1-modifyConfig%0D%0A++++name%3A+modify+packet+gen+config%0D%0A++++description%3A%0D%0A++++actor%3A+APPC%0D%0A++++recipe%3A+ModifyConfig%0D%0A++++target%3A%0D%0A++++++%23+TBD+-+Cannot+be+known+until+instantiation+is+done%0D%0A++++++resourceID%3A+'${RESOURCE_ID}'%0D%0A++++++type%3A+VNF%0D%0A++++retry%3A+0%0D%0A++++timeout%3A+300%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
    }
  }
}' http://${K8S_HOST}:${POLICY_PDP_PORT}/pdp/api/updatePolicy

sleep 5

echo
echo
echo "Pushing the vFW Policy .."
echo
echo

curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvFirewall",
  "policyType": "BRMS_Param"
}' http://${K8S_HOST}:${POLICY_PDP_PORT}/pdp/api/pushPolicy

sleep 20

echo
echo
echo "Restarting PDP-D .."
echo
echo 

POD=$(kubectl --namespace onap-policy get pods | sed 's/ .*//'| grep drools)
kubectl --namespace onap-policy exec -it ${POD} -- bash -c "source /opt/app/policy/etc/profile.d/env.sh && policy stop && sleep 5 && policy start"

sleep 20

echo
echo
echo "PDP-D amsterdam maven coordinates .."
echo
echo

curl -vvv --silent --user @1b3rt:31nst31n -X GET http://${K8S_HOST}:${POLICY_DROOLS_PORT}/policy/pdp/engine/controllers/amsterdam/drools  | python -m json.tool


echo
echo
echo "PDP-D control loop updated .."
echo
echo

curl -v --silent --user @1b3rt:31nst31n -X GET http://${K8S_HOST}:${POLICY_DROOLS_PORT}/policy/pdp/engine/controllers/amsterdam/drools/facts/closedloop-amsterdam/org.onap.policy.controlloop.Params  | python -m json.tool
