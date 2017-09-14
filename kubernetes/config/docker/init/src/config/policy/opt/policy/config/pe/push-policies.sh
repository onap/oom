#! /bin/bash


echo "Pushing default policies"

# Sometimes brmsgw gets an error when trying to retrieve the policies on initial push,
# so for the BRMS policies we will do a push, then delete from the pdp group, then push again.
# Second push should be successful.

echo "pushPolicy : PUT : com.vFirewall"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.vFirewall",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.vLoadBalancer"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.vLoadBalancer",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy' 

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvLBDemoPolicy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvLBDemoPolicy",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvFWDemoPolicy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvFWDemoPolicy",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "deletePolicy : DELETE : com.vFirewall"
curl -v --silent -X DELETE --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
"pdpGroup": "default",
"policyComponent": "PDP",
"policyName": "com.vFirewall",
"policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/deletePolicy'


sleep 2

echo "deletePolicy : DELETE : com.vLoadBalancer"
curl -v --silent -X DELETE --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
"pdpGroup": "default",
"policyComponent": "PDP",
"policyName": "com.vLoadBalancer",
"policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/deletePolicy'

sleep 2

echo "deletePolicy : DELETE : com.BRMSParamvFWDemoPolicy"
curl -v --silent -X DELETE --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
"pdpGroup": "default",
"policyComponent": "PDP",
"policyName": "com.BRMSParamvFWDemoPolicy",
"policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/deletePolicy'


sleep 2

echo "deletePolicy : DELETE : com.BRMSParamvLBDemoPolicy"
curl -v --silent -X DELETE --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
"pdpGroup": "default",
"policyComponent": "PDP",
"policyName": "com.BRMSParamvLBDemoPolicy",
"policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/deletePolicy'

sleep 2

echo "pushPolicy : PUT : com.vFirewall"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.vFirewall",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.vLoadBalancer"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.vLoadBalancer",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy' 

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvLBDemoPolicy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvLBDemoPolicy",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvFWDemoPolicy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvFWDemoPolicy",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

