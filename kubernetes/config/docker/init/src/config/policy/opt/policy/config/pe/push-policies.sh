#! /bin/bash

#########################################Upload BRMS Param Template##########################################

echo "Upload BRMS Param Template"

sleep 2

wget -O cl-amsterdam-template.drl https://git.onap.org/policy/drools-applications/plain/controlloop/templates/archetype-cl-amsterdam/src/main/resources/archetype-resources/src/main/resources/__closedLoopControlName__.drl

sleep 2

curl -v --silent -X POST --header 'Content-Type: multipart/form-data' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -F "file=@cl-amsterdam-template.drl" -F "importParametersJson={\"serviceName\":\"ClosedLoopControlName\",\"serviceType\":\"BRMSPARAM\"}" 'http://pdp.onap-policy:8081/pdp/api/policyEngineImport' 

echo "PRELOAD_POLICIES is $PRELOAD_POLICIES"

if [ "$PRELOAD_POLICIES" == "false" ]; then
    exit 0
fi

#########################################Create BRMS Param policies##########################################

echo "Create BRMSParam Operational Policies"

sleep 2

echo "Create BRMSParamvFirewall Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"policyConfigType": "BRMS_PARAM",
	"policyName": "com.BRMSParamvFirewall",
	"policyDescription": "BRMS Param vFirewall policy",
	"policyScope": "com",
	"attributes": {
		"MATCHING": {
	    	"controller" : "amsterdam"
	    },
		"RULE": {
			"templateName": "ClosedLoopControlName",
			"closedLoopControlName": "ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a",
			"controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+2.0.0%0D%0A++controlLoopName%3A+ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a%0D%0A++trigger_policy%3A+unique-policy-id-1-modifyConfig%0D%0A++timeout%3A+1200%0D%0A++abatement%3A+false%0D%0A+%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-1-modifyConfig%0D%0A++++name%3A+modify+packet+gen+config%0D%0A++++description%3A%0D%0A++++actor%3A+APPC%0D%0A++++recipe%3A+ModifyConfig%0D%0A++++target%3A%0D%0A++++++%23+TBD+-+Cannot+be+known+until+instantiation+is+done%0D%0A++++++resourceID%3A+Eace933104d443b496b8.nodes.heat.vpg%0D%0A++++++type%3A+VNF%0D%0A++++retry%3A+0%0D%0A++++timeout%3A+300%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
		}
	}
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamvDNS Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"policyConfigType": "BRMS_PARAM",
	"policyName": "com.BRMSParamvDNS",
	"policyDescription": "BRMS Param vDNS policy",
	"policyScope": "com",
	"attributes": {
		"MATCHING": {
	    	"controller" : "amsterdam"
	    },
		"RULE": {
			"templateName": "ClosedLoopControlName",
			"closedLoopControlName": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
			"controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+2.0.0%0D%0A++controlLoopName%3A+ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3%0D%0A++trigger_policy%3A+unique-policy-id-1-scale-up%0D%0A++timeout%3A+1200%0D%0A++abatement%3A+false%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-1-scale-up%0D%0A++++name%3A+Create+a+new+VF+Module%0D%0A++++description%3A%0D%0A++++actor%3A+SO%0D%0A++++recipe%3A+VF+Module+Create%0D%0A++++target%3A%0D%0A++++++type%3A+VNF%0D%0A++++retry%3A+0%0D%0A++++timeout%3A+1200%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
		}
	}
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamVOLTE Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"policyConfigType": "BRMS_PARAM",
	"policyName": "com.BRMSParamVOLTE",
	"policyDescription": "BRMS Param VOLTE policy",
	"policyScope": "com",
	"attributes": {
		"MATCHING": {
	    	"controller" : "amsterdam"
	    },
		"RULE": {
			"templateName": "ClosedLoopControlName",
			"closedLoopControlName": "ControlLoop-VOLTE-2179b738-fd36-4843-a71a-a8c24c70c55b",
			"controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+2.0.0%0D%0A++controlLoopName%3A+ControlLoop-VOLTE-2179b738-fd36-4843-a71a-a8c24c70c55b%0D%0A++trigger_policy%3A+unique-policy-id-1-restart%0D%0A++timeout%3A+3600%0D%0A++abatement%3A+false%0D%0A+%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-1-restart%0D%0A++++name%3A+Restart+the+VM%0D%0A++++description%3A%0D%0A++++actor%3A+VFC%0D%0A++++recipe%3A+Restart%0D%0A++++target%3A%0D%0A++++++type%3A+VM%0D%0A++++retry%3A+3%0D%0A++++timeout%3A+1200%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
		}
	}
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamvCPE Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"policyConfigType": "BRMS_PARAM",
	"policyName": "com.BRMSParamvCPE",
	"policyDescription": "BRMS Param vCPE policy",
	"policyScope": "com",
	"attributes": {
	    "MATCHING": {
	    	"controller" : "amsterdam"
	    },
		"RULE": {
			"templateName": "ClosedLoopControlName",
			"closedLoopControlName": "ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e",
			"controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+2.0.0%0D%0A++controlLoopName%3A+ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e%0D%0A++trigger_policy%3A+unique-policy-id-1-restart%0D%0A++timeout%3A+3600%0D%0A++abatement%3A+true%0D%0A+%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-1-restart%0D%0A++++name%3A+Restart+the+VM%0D%0A++++description%3A%0D%0A++++actor%3A+APPC%0D%0A++++recipe%3A+Restart%0D%0A++++target%3A%0D%0A++++++type%3A+VM%0D%0A++++retry%3A+3%0D%0A++++timeout%3A+1200%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
		}
	}
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'

#########################################Create Micro Service Config policies##########################################

echo "Create MicroService Config Policies"

sleep 2

echo "Create MicroServicevFirewall Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation\", \"uuid\": \"test\", \"policyName\": \"MicroServicevFirewall\", \"description\": \"MicroService vFirewall Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"vFirewallBroadcastPackets\", \"controlLoopSchemaType\": \"VNF\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.vNicUsageArray[*].receivedTotalPacketsDelta\", \"thresholdValue\": 300, \"direction\": \"LESS_OR_EQUAL\", \"severity\": \"MAJOR\", \"closedLoopEventStatus\": \"ONSET\" }, { \"closedLoopControlName\": \"ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.vNicUsageArray[*].receivedTotalPacketsDelta\", \"thresholdValue\": 700, \"direction\": \"GREATER_OR_EQUAL\", \"severity\": \"CRITICAL\", \"closedLoopEventStatus\": \"ONSET\" } ] }] } } }",
	"policyConfigType": "MicroService",
	"policyName": "com.MicroServicevFirewall",
	"onapName": "DCAE"
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'


sleep 2

echo "Create MicroServicevDNS Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation\", \"uuid\": \"test\", \"policyName\": \"MicroServicevDNS\", \"description\": \"MicroService vDNS Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"vLoadBalancer\", \"controlLoopSchemaType\": \"VM\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.vNicUsageArray[*].receivedTotalPacketsDelta\", \"thresholdValue\": 300, \"direction\": \"GREATER_OR_EQUAL\", \"severity\": \"CRITICAL\", \"closedLoopEventStatus\": \"ONSET\" }] }] } } }",
	"policyConfigType": "MicroService",
	"policyName": "com.MicroServicevDNS",
	"onapName": "DCAE"
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'


sleep 2

echo "Create MicroServicevCPE Policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
	"configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation\", \"uuid\": \"test\", \"policyName\": \"MicroServicevCPE\", \"description\": \"MicroService vCPE Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"Measurement_vGMUX\", \"controlLoopSchemaType\": \"VNF\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.additionalMeasurements[*].arrayOfFields[0].value\", \"thresholdValue\": 0, \"direction\": \"EQUAL\", \"severity\": \"MAJOR\", \"closedLoopEventStatus\": \"ABATED\" }, { \"closedLoopControlName\": \"ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.additionalMeasurements[*].arrayOfFields[0].value\", \"thresholdValue\": 0, \"direction\": \"GREATER\", \"severity\": \"CRITICAL\", \"closedLoopEventStatus\": \"ONSET\" }] }] } } }",
	"policyConfigType": "MicroService",
	"policyName": "com.MicroServicevCPE",
	"onapName": "DCAE"
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'


#########################################Creating Decision Guard policy######################################### 

sleep 2

echo "Creating Decision Guard policy"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{ 
	"policyClass": "Decision", 
	"policyName": "com.AllPermitGuard", 
	"policyDescription": "Testing all Permit YAML Guard Policy", 
	"ecompName": "PDPD", 
	"ruleProvider": "GUARD_YAML", 
	"attributes": { 
		"MATCHING": { 
			"actor": ".*", 
			"recipe": ".*", 
			"targets": ".*", 
			"clname": ".*", 
			"limit": "10", 
			"timeWindow": "1", 
			"timeUnits": "minute", 
			"guardActiveStart": "00:00:01-05:00", 
			"guardActiveEnd": "00:00:00-05:00" 
		} 
	} 
}' 'http://pdp.onap-policy:8081/pdp/api/createPolicy'

#########################################Push Decision policy#########################################

sleep 2

echo "Push Decision policy" 
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{ 
  "pdpGroup": "default", 
  "policyName": "com.AllPermitGuard", 
  "policyType": "DECISION" 
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

#########################################Pushing BRMS Param policies##########################################

echo "Pushing BRMSParam Operational policies"

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvFirewall"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvFirewall",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvDNS"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvDNS",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamVOLTE"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamVOLTE",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvCPE"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvCPE",
  "policyType": "BRMS_Param"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

#########################################Pushing MicroService Config policies##########################################

echo "Pushing MicroService Config policies"

sleep 2

echo "pushPolicy : PUT : com.MicroServicevFirewall"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevFirewall",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy'

sleep 10

echo "pushPolicy : PUT : com.MicroServicevDNS"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevDNS",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy' 

sleep 10

echo "pushPolicy : PUT : com.MicroServicevCPE"
curl -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevCPE",
  "policyType": "MicroService"
}' 'http://pdp.onap-policy:8081/pdp/api/pushPolicy' 