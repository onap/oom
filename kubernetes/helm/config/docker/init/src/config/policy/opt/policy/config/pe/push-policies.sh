#! /bin/bash


echo "Pushing default policies"

# Sometimes brmsgw gets an error when trying to retrieve the policies on initial push,
# so for the BRMS policies we will do a push, then delete from the pdp group, then push again.
# Second push should be successful.

curl -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "vFirewall",
  "policyScope": "com",
  "policyType": "MicroService"
}' 'http://pypdp:8480/PyPDPServer/pushPolicy'

sleep 2

curl -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "vLoadBalancer",
  "policyScope": "com",
  "policyType": "MicroService"
}' 'http://pypdp:8480/PyPDPServer/pushPolicy' 

sleep 2
curl -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "BRMSParamvLBDemoPolicy",
  "policyScope": "com",
  "policyType": "BRMS_Param"
}' 'http://pypdp:8480/PyPDPServer/pushPolicy'

sleep 2

curl -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "BRMSParamvFWDemoPolicy",
  "policyScope": "com",
  "policyType": "BRMS_Param"
}' 'http://pypdp:8480/PyPDPServer/pushPolicy'

sleep 2

curl -X DELETE --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
"pdpGroup": "default",
"policyComponent": "PDP",
"policyName": "com.Config_BRMS_Param_BRMSParamvFWDemoPolicy.1.xml"
}' 'http://pypdp:8480/PyPDPServer/deletePolicy'



curl -X DELETE --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
"pdpGroup": "default",
"policyComponent": "PDP",
"policyName": "com.Config_BRMS_Param_BRMSParamvLBDemoPolicy.1.xml"
}' 'http://pypdp:8480/PyPDPServer/deletePolicy'

sleep 2
curl -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "BRMSParamvLBDemoPolicy",
  "policyScope": "com",
  "policyType": "BRMS_Param"
}' 'http://pypdp:8480/PyPDPServer/pushPolicy'

sleep 2

curl -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHJlc3Q6M2MwbXBVI2gwMUBOMWMz' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "BRMSParamvFWDemoPolicy",
  "policyScope": "com",
  "policyType": "BRMS_Param"
}' 'http://pypdp:8480/PyPDPServer/pushPolicy'

