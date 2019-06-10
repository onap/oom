# Copyright © 2017 Amdocs, Bell Canada, AT&T
# Modifications Copyright © 2018-2019 AT&T. All rights reserved.
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

#! /bin/bash

# forked from https://gerrit.onap.org/r/gitweb?p=policy/docker.git;a=blob;f=config/pe/push-policies.sh;h=555ab357e6b4f54237bf07ef5e6777d782564bc0;hb=refs/heads/amsterdam and adapted for OOM

#########################################Upload BRMS Param Template##########################################

echo "Upload BRMS Param Template"

sleep 2

wget -O cl-amsterdam-template.drl https://git.onap.org/policy/drools-applications/plain/controlloop/templates/archetype-cl-amsterdam/src/main/resources/archetype-resources/src/main/resources/__closedLoopControlName__.drl

sleep 2

curl -k -v --silent -X POST --header 'Content-Type: multipart/form-data' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -F "file=@cl-amsterdam-template.drl" -F "importParametersJson={\"serviceName\":\"ClosedLoopControlName\",\"serviceType\":\"BRMSPARAM\"}" 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/policyEngineImport'

echo "PRELOAD_POLICIES is $PRELOAD_POLICIES"

if [ "$PRELOAD_POLICIES" == "false" ]; then
    exit 0
fi

#########################################Create BRMS Param policies##########################################

echo "Create BRMSParam Operational Policies"

sleep 2

echo "Create BRMSParamvFirewall Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
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
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamvDNS Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
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
            "controlLoopYaml": "controlLoop%3A%0A++version%3A+2.0.0%0A++controlLoopName%3A+ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3%0A++trigger_policy%3A+unique-policy-id-1-scale-up%0A++timeout%3A+1200%0A++abatement%3A+false%0Apolicies%3A%0A++-+id%3A+unique-policy-id-1-scale-up%0A++++name%3A+Create+a+new+VF+Module%0A++++description%3A%0A++++actor%3A+SO%0A++++recipe%3A+VF+Module+Create%0A++++target%3A%0A++++++type%3A+VNF%0A++++payload%3A%0A++++++requestParameters%3A+%27%7B%22usePreload%22%3Atrue%2C%22userParams%22%3A%5B%5D%7D%27%0A++++++configurationParameters%3A+%27%5B%7B%22ip-addr%22%3A%22%24.vf-module-topology.vf-module-parameters.param%5B9%5D%22%2C%22oam-ip-addr%22%3A%22%24.vf-module-topology.vf-module-parameters.param%5B16%5D%22%2C%22enabled%22%3A%22%24.vf-module-topology.vf-module-parameters.param%5B23%5D%22%7D%5D%27%0A++++retry%3A+0%0A++++timeout%3A+1200%0A++++success%3A+final_success%0A++++failure%3A+final_failure%0A++++failure_timeout%3A+final_failure_timeout%0A++++failure_retries%3A+final_failure_retries%0A++++failure_exception%3A+final_failure_exception%0A++++failure_guard%3A+final_failure_guard"
        }
    }
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamVOLTE Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
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
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamvCPE Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
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
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamvPCI Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "policyConfigType": "BRMS_PARAM",
    "policyName": "com.BRMSParamvPCI",
    "policyDescription": "BRMS Param vPCI policy",
    "policyScope": "com",
    "attributes": {
        "MATCHING": {
            "controller" : "casablanca"
        },
        "RULE": {
            "templateName": "ClosedLoopControlName",
            "closedLoopControlName": "ControlLoop-vPCI-fb41f388-a5f2-11e8-98d0-529269fb1459",
            "controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+3.0.0%0D%0A++controlLoopName%3A+ControlLoop-vPCI-fb41f388-a5f2-11e8-98d0-529269fb1459%0D%0A++trigger_policy%3A+unique-policy-id-123-modifyconfig%0D%0A++timeout%3A+1200%0D%0A++abatement%3A+false%0D%0A+%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-123-modifyconfig%0D%0A++++name%3A+modify+PCI+config%0D%0A++++description%3A%0D%0A++++actor%3A+SDNR%0D%0A++++recipe%3A+ModifyConfig%0D%0A++++target%3A%0D%0A++++++%23+These+fields+are+not+used%0D%0A++++++resourceID%3A+Eace933104d443b496b8.nodes.heat.vpg%0D%0A++++++type%3A+VNF%0D%0A++++retry%3A+0%0D%0A++++timeout%3A+300%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
        }
    }
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create BRMSParamCCVPN Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/html' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "policyConfigType": "BRMS_PARAM",
    "policyName": "com.BRMSParamCCVPN",
    "policyDescription": "BRMS Param CCVPN policy",
    "policyScope": "com",
    "attributes": {
        "MATCHING": {
            "controller" : "amsterdam"
        },
        "RULE": {
            "templateName": "ClosedLoopControlName",
            "closedLoopControlName": "ControlLoop-CCVPN-2179b738-fd36-4843-a71a-a8c24c70c66b",
            "controlLoopYaml": "controlLoop%3A%0D%0A++version%3A+2.0.0%0D%0A++controlLoopName%3A+ControlLoop-CCVPN-2179b738-fd36-4843-a71a-a8c24c70c66b%0D%0A++trigger_policy%3A+unique-policy-id-16-Reroute%0D%0A++timeout%3A+3600%0D%0A++abatement%3A+false%0D%0A+%0D%0Apolicies%3A%0D%0A++-+id%3A+unique-policy-id-16-Reroute%0D%0A++++name%3A+Connectivity Reroute%0D%0A++++description%3A%0D%0A++++actor%3A+SDNC%0D%0A++++recipe%3A+Reroute%0D%0A++++target%3A%0D%0A++++++type%3A+VM%0D%0A++++retry%3A+3%0D%0A++++timeout%3A+1200%0D%0A++++success%3A+final_success%0D%0A++++failure%3A+final_failure%0D%0A++++failure_timeout%3A+final_failure_timeout%0D%0A++++failure_retries%3A+final_failure_retries%0D%0A++++failure_exception%3A+final_failure_exception%0D%0A++++failure_guard%3A+final_failure_guard"
        }
    }
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

#########################################Create Micro Service Config policies##########################################

echo "Create MicroService Config Policies"

sleep 2

echo "Create MicroServicevFirewall Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation\", \"uuid\": \"test\", \"policyName\": \"MicroServicevFirewall\", \"description\": \"MicroService vFirewall Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"vFirewallBroadcastPackets\", \"controlLoopSchemaType\": \"VNF\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.vNicUsageArray[*].receivedTotalPacketsDelta\", \"thresholdValue\": 300, \"direction\": \"LESS_OR_EQUAL\", \"severity\": \"MAJOR\", \"closedLoopEventStatus\": \"ONSET\" }, { \"closedLoopControlName\": \"ControlLoop-vFirewall-d0a1dfc6-94f5-4fd4-a5b5-4630b438850a\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.vNicUsageArray[*].receivedTotalPacketsDelta\", \"thresholdValue\": 700, \"direction\": \"GREATER_OR_EQUAL\", \"severity\": \"CRITICAL\", \"closedLoopEventStatus\": \"ONSET\" } ] }] } } }",
    "policyConfigType": "MicroService",
    "policyName": "com.MicroServicevFirewall",
    "onapName": "DCAE"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'


sleep 2

echo "Create MicroServicevDNS Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation\", \"uuid\": \"test\", \"policyName\": \"MicroServicevDNS\", \"description\": \"MicroService vDNS Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"vLoadBalancer\", \"controlLoopSchemaType\": \"VM\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.vNicUsageArray[*].receivedTotalPacketsDelta\", \"thresholdValue\": 300, \"direction\": \"GREATER_OR_EQUAL\", \"severity\": \"CRITICAL\", \"closedLoopEventStatus\": \"ONSET\" }] }] } } }",
    "policyConfigType": "MicroService",
    "policyName": "com.MicroServicevDNS",
    "onapName": "DCAE"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'


sleep 2

echo "Create MicroServicevCPE Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation\", \"uuid\": \"test\", \"policyName\": \"MicroServicevCPE\", \"description\": \"MicroService vCPE Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"Measurement_vGMUX\", \"controlLoopSchemaType\": \"VNF\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.additionalMeasurements[*].arrayOfFields[0].value\", \"thresholdValue\": 0, \"direction\": \"EQUAL\", \"severity\": \"MAJOR\", \"closedLoopEventStatus\": \"ABATED\" }, { \"closedLoopControlName\": \"ControlLoop-vCPE-48f0c2c3-a172-4192-9ae3-052274181b6e\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.measurementsForVfScalingFields.additionalMeasurements[*].arrayOfFields[0].value\", \"thresholdValue\": 0, \"direction\": \"GREATER\", \"severity\": \"CRITICAL\", \"closedLoopEventStatus\": \"ONSET\" }] }] } } }",
    "policyConfigType": "MicroService",
    "policyName": "com.MicroServicevCPE",
    "onapName": "DCAE"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

#########################################Create SDNC Naming Policies##########################################

echo "Create Generic SDNC Naming Policy for VNF"

sleep 2

echo "Create SDNC vFW Naming Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "configBody": "{ \"service\": \"SDNC-GenerateName\", \"version\": \"CSIT\", \"content\": { \"policy-instance-name\": \"ONAP_VNF_NAMING_TIMESTAMP\", \"naming-models\": [ { \"naming-properties\": [ { \"property-name\": \"AIC_CLOUD_REGION\" }, { \"property-name\": \"CONSTANT\", \"property-value\": \"ONAP-NF\" }, { \"property-name\": \"TIMESTAMP\" }, { \"property-value\": \"_\", \"property-name\": \"DELIMITER\" } ], \"naming-type\": \"VNF\", \"naming-recipe\": \"AIC_CLOUD_REGION|DELIMITER|CONSTANT|DELIMITER|TIMESTAMP\" }, { \"naming-properties\": [ { \"property-name\": \"VNF_NAME\" }, { \"property-name\": \"SEQUENCE\", \"increment-sequence\": { \"max\": \"zzz\", \"scope\": \"ENTIRETY\", \"start-value\": \"001\", \"length\": \"3\", \"increment\": \"1\", \"sequence-type\": \"alpha-numeric\" } }, { \"property-name\": \"NFC_NAMING_CODE\" }, { \"property-value\": \"_\", \"property-name\": \"DELIMITER\" } ], \"naming-type\": \"VNFC\", \"naming-recipe\": \"VNF_NAME|DELIMITER|NFC_NAMING_CODE|DELIMITER|SEQUENCE\" }, { \"naming-properties\": [ { \"property-name\": \"VNF_NAME\" }, { \"property-value\": \"_\", \"property-name\": \"DELIMITER\" }, { \"property-name\": \"VF_MODULE_LABEL\" }, { \"property-name\": \"VF_MODULE_TYPE\" }, { \"property-name\": \"SEQUENCE\", \"increment-sequence\": { \"max\": \"zzz\", \"scope\": \"PRECEEDING\", \"start-value\": \"01\", \"length\": \"3\", \"increment\": \"1\", \"sequence-type\": \"alpha-numeric\" } } ], \"naming-type\": \"VF-MODULE\", \"naming-recipe\": \"VNF_NAME|DELIMITER|VF_MODULE_LABEL|DELIMITER|VF_MODULE_TYPE|DELIMITER|SEQUENCE\" } ] } }",
    "policyName": "SDNC_Policy.ONAP_VNF_NAMING_TIMESTAMP",
    "policyConfigType": "MicroService",
    "onapName": "SDNC",
    "riskLevel": "4",
    "riskType": "test",
    "guard": "false",
    "priority": "4",
    "description": "ONAP_VNF_NAMING_TIMESTAMP"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

#########################################Creating OOF PCI Policies##########################################
sleep 2

echo "Create MicroServicevPCI Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
        "configBody": "{ \"service\": \"tca_policy\", \"location\": \"SampleServiceLocation_pci\", \"uuid\": \"test_pci\", \"policyName\": \"MicroServicevPCI\", \"description\": \"MicroService vPCI Policy\", \"configName\": \"SampleConfigName\", \"templateVersion\": \"OpenSource.version.1\", \"version\": \"1.1.0\", \"priority\": \"1\", \"policyScope\": \"resource=SampleResource,service=SampleService,type=SampleType,closedLoopControlName=ControlLoop-vPCI-fb41f388-a5f2-11e8-98d0-529269fb1459\", \"riskType\": \"SampleRiskType\", \"riskLevel\": \"1\", \"guard\": \"False\", \"content\": { \"tca_policy\": { \"domain\": \"measurementsForVfScaling\", \"metricsPerEventName\": [{ \"eventName\": \"vFirewallBroadcastPackets\", \"controlLoopSchemaType\": \"VNF\", \"policyScope\": \"DCAE\", \"policyName\": \"DCAE.Config_tca-hi-lo\", \"policyVersion\": \"v0.0.1\", \"thresholds\": [{ \"closedLoopControlName\": \"ControlLoop-vPCI-fb41f388-a5f2-11e8-98d0-529269fb1459\", \"version\": \"1.0.2\", \"fieldPath\": \"$.event.executePolicy\", \"thresholdValue\": 1, \"direction\": \"GREATER_OR_EQUAL\", \"severity\": \"MAJOR\", \"closedLoopEventStatus\": \"ONSET\" } ] }] } } }",
        "policyConfigType": "MicroService",
        "policyName": "com.MicroServicevPCI",
        "onapName": "DCAE"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create PCI MS Config Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "policyName": "com.PCIMS_CONFIG_POLICY",
  "configBody": "{ \"PCI_NEIGHBOR_CHANGE_CLUSTER_TIMEOUT_IN_SECS\":60, \"PCI_MODCONFIG_POLICY_NAME\":\"ControlLoop-vPCI-fb41f388-a5f2-11e8-98d0-529269fb1459\", \"PCI_OPTMIZATION_ALGO_CATEGORY_IN_OOF\":\"OOF-PCI-OPTIMIZATION\", \"PCI_SDNR_TARGET_NAME\":\"SDNR\" }",
  "policyType": "Config",
  "attributes" : { "matching" : { "key1" : "value1" } },
  "policyConfigType": "Base",
  "onapName": "DCAE",
  "configName": "PCIMS_CONFIG_POLICY",
  "configBodyType": "JSON"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Create OOF Config Policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "policyName": "com.OOF_PCI_CONFIG_POLICY",
  "configBody": "{ \"ALGO_CATEGORY\":\"OOF-PCI-OPTIMIZATION\", \"PCI_OPTMIZATION_ALGO_NAME\":\"OOF-PCI-OPTIMIZATION-LEVEL1\", \"PCI_OPTIMIZATION_NW_CONSTRAINT\":\"MAX5PCICHANGESONLY\", \"PCI_OPTIMIZATION_PRIORITY\": 2, \"PCI_OPTIMIZATION_TIME_CONSTRAINT\":\"ONLYATNIGHT\" }",
  "attributes" : { "matching" : { "key1" : "value1" } },
  "policyType": "Config",
  "policyConfigType": "Base",
  "onapName": "DCAE",
  "configName": "OOF_PCI_CONFIG_POLICY",
  "configBodyType": "JSON"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

#########################################Creating Decision Guard policies#########################################

sleep 2

echo "Creating Decision Guard policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "policyClass": "Decision",
    "policyName": "com.AllPermitGuard",
    "policyDescription": "Testing all Permit YAML Guard Policy",
    "onapName": "PDPD",
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
            "guardActiveEnd": "23:59:59-05:00"
        }
    }
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Creating Decision vDNS Guard - Frequency Limiter policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "policyClass": "Decision",
    "policyName": "com.vDNS_Frequency",
    "policyDescription": "Limit vDNS Scale Up over time period",
    "onapName": "PDPD",
    "ruleProvider": "GUARD_YAML",
    "attributes": {
        "MATCHING": {
            "actor": "SO",
            "recipe": "scaleOut",
            "targets": ".*",
            "clname": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
            "limit": "1",
            "timeWindow": "10",
            "timeUnits": "minute",
            "guardActiveStart": "00:00:01-05:00",
            "guardActiveEnd": "23:59:59-05:00"
        }
    }
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

sleep 2

echo "Creating Decision vDNS Guard - Min/Max policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
    "policyClass": "Decision",
    "policyName": "com.vDNS_MinMax",
    "policyDescription": "Ensure number of instances within a range",
    "onapName": "SampleDemo",
    "ruleProvider": "GUARD_MIN_MAX",
    "attributes": {
        "MATCHING": {
            "actor": "SO",
            "recipe": "scaleOut",
            "targets": ".*",
            "clname": "ControlLoop-vDNS-6f37f56d-a87d-4b85-b6a9-cc953cf779b3",
            "min": "1",
            "max": "5",
            "guardActiveStart": "00:00:01-05:00",
            "guardActiveEnd": "23:59:59-05:00"
        }
    }
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/createPolicy'

#########################################Push Decision policy#########################################

sleep 2

echo "Push Decision policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.AllPermitGuard",
  "policyType": "DECISION"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "Push Decision policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.vDNS_Frequency",
  "policyType": "DECISION"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "Push Decision policy"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.vDNS_MinMax",
  "policyType": "DECISION"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

#########################################Pushing BRMS Param policies##########################################

echo "Pushing BRMSParam Operational policies"

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvFirewall"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvFirewall",
  "policyType": "BRMS_Param"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvDNS"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvDNS",
  "policyType": "BRMS_Param"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamVOLTE"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamVOLTE",
  "policyType": "BRMS_Param"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvCPE"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvCPE",
  "policyType": "BRMS_Param"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamvPCI"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamvPCI",
  "policyType": "BRMS_Param"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 2

echo "pushPolicy : PUT : com.BRMSParamCCVPN"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.BRMSParamCCVPN",
  "policyType": "BRMS_Param"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

#########################################Pushing MicroService Config policies##########################################

echo "Pushing MicroService Config policies"

sleep 2

echo "pushPolicy : PUT : com.MicroServicevFirewall"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevFirewall",
  "policyType": "MicroService"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 10

echo "pushPolicy : PUT : com.MicroServicevDNS"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevDNS",
  "policyType": "MicroService"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 10

echo "pushPolicy : PUT : com.MicroServicevCPE"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevCPE",
  "policyType": "MicroService"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

#########################################Pushing SDNC Naming Policies##########################################
echo "Pushing SDNC Naming Policies"

sleep 2

echo "pushPolicy : PUT : SDNC_Policy.ONAP_VNF_NAMING_TIMESTAMP"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "SDNC_Policy.ONAP_VNF_NAMING_TIMESTAMP",
  "policyType": "MicroService"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

#########################################Pushing OOF PCI Policies##########################################
sleep 10

echo "pushPolicy : PUT : com.MicroServicevPCI"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.MicroServicevPCI",
  "policyType": "MicroService"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 10

echo "pushPolicy : PUT : com.PCIMS_CONFIG_POLICY"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.PCIMS_CONFIG_POLICY",
  "policyType": "Base"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'

sleep 10

echo "pushPolicy : PUT : com.OOF_PCI_CONFIG_POLICY"
curl -k -v --silent -X PUT --header 'Content-Type: application/json' --header 'Accept: text/plain' --header 'ClientAuth: cHl0aG9uOnRlc3Q=' --header 'Authorization: Basic dGVzdHBkcDphbHBoYTEyMw==' --header 'Environment: TEST' -d '{
  "pdpGroup": "default",
  "policyName": "com.OOF_PCI_CONFIG_POLICY",
  "policyType": "Base"
}' 'https://{{.Values.global.pdp.nameOverride}}:{{.Values.config.pdpPort}}/pdp/api/pushPolicy'
