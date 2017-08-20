*** Settings ***
Documentation	  Policy Closed Loop Test cases

Resource          ../policy_interface.robot
Resource        ../stack_validation/policy_check_vfw.robot
Resource        vnf_orchestration_test_template.robot
Library    String
Library    HttpLibrary.HTTP
LIbrary    Process

*** Variables ***
${RESOURCE_PATH_CREATE}        /PyPDPServer/createPolicy
${RESOURCE_PATH_CREATE_PUSH}        /PyPDPServer/pushPolicy
${RESOURCE_PATH_CREATE_DELETE}        /PyPDPServer/deletePolicy
${RESOURCE_PATH_GET_CONFIG}    /PyPDPServer/getConfig
${CREATE_CONFIG_TEMPLATE}    robot/assets/templates/policy/closedloop_configpolicy.template
${CREATE_OPS_TEMPLATE}    robot/assets/templates/policy/closedloop_opspolicy.template
${PUSH_POLICY_TEMPLATE}   robot/assets/templates/policy/closedloop_pushpolicy.template
${DEL_POLICY_TEMPLATE}   robot/assets/templates/policy/closedloop_deletepolicy.template
${GECONFIG_VFW_TEMPLATE}    robot/assets/templates/policy/closedloop_getconfigpolicy.template

# 'Normal' number of pg streams that will be set when policy is triggered
${VFWPOLICYRATE}    5

# Max nslookup requests per second before triggering event.
${VLBPOLICYRATE}    20

${CONFIG_POLICY_NAME}    vFirewall
${CONFIG_POLICY_TYPE}    Unknown
${OPS_POLICY_NAME}
${OPS_POLICY_TYPE}    BRMS_PARAM

# VFW low threshold
${Expected_Severity_1}    MAJOR
${Expected_Threshold_1}    300
${Expected_Direction_1}    LESS_OR_EQUAL

# VFW high threshold
${Expected_Severity_2}    CRITICAL
${Expected_Threshold_2}    700
${Expected_Direction_2}    GREATER_OR_EQUAL

# VDNS High threshold
${Expected_Severity_3}    MAJOR
${Expected_Threshold_3}    200
${Expected_Direction_3}    GREATER_OR_EQUAL

#********** Test Case Variables ************
${DNSSCALINGSTACK}

*** Keywords ***
VFW Policy
    Log    Suite name ${SUITE NAME} ${TEST NAME} ${PREV TEST NAME}
    Initialize VFW Policy
    ${stackname}=   Orchestrate VNF vFW closedloop
    Policy Check Firewall Stack    ${stackname}    ${VFWPOLICYRATE}


VDNS Policy
    Initialize VDNS Policy
    ${stackname}=   Orchestrate VNF vDNS closedloop
    ${dnsscaling}=   Policy Check vLB Stack    ${stackname}    ${VLBPOLICYRATE}
    Set Test Variable   ${DNSSCALINGSTACK}   ${dnsscaling}

Initialize VFW Policy
#    Create Config Policy
#    Push Config Policy    ${CONFIG_POLICY_NAME}    ${CONFIG_POLICY_TYPE}
#    Create Ops Policy
#    Push Ops Policy    ${OPS_POLICY_NAME}    ${OPS_POLICY_TYPE}
     Get Configs VFW Policy

Initialize VDNS Policy
    Get Configs VDNS Policy

Get Configs VFW Policy
    [Documentation]    Get Config Policy for VFW
    ${getconfigpolicy}=    Catenate    .*${CONFIG_POLICY_NAME}*
    ${configpolicy_name}=    Create Dictionary    config_policy_name=${getconfigpolicy}
    ${output} =     Fill JSON Template File     ${GECONFIG_VFW_TEMPLATE}    ${configpolicy_name}
    ${get_resp} =    Run Policy Get Configs Request    ${RESOURCE_PATH_GET_CONFIG}   ${output}
	Should Be Equal As Strings 	${get_resp.status_code} 	200

	${json}=    Parse Json    ${get_resp.content}
    ${config}=    Parse Json    ${json[0]["config"]}

    # Extract object1 from Array
    ${severity}=    Get Variable Value      ${config["content"]["thresholds"][0]["severity"]}
    Should Be Equal    ${severity}    ${Expected_Severity_1}
    ${Thresold_Value}=    Get Variable Value      ${config["content"]["thresholds"][0]["thresholdValue"]}
    Should Be Equal   ${Thresold_Value}    ${Expected_Threshold_1}
    ${direction}=    Get Variable Value      ${config["content"]["thresholds"][0]["direction"]}
    Should Be Equal   ${direction}    ${Expected_Direction_1}

    # Extract object2 from Array
    ${severity_1}=    Get Variable Value      ${config["content"]["thresholds"][1]["severity"]}
    Should Be Equal    ${severity_1}    ${Expected_Severity_2}
    ${Thresold_Value_1}=    Get Variable Value      ${config["content"]["thresholds"][1]["thresholdValue"]}
    Should Be Equal   ${Thresold_Value_1}    ${Expected_Threshold_2}
    ${direction_1}=    Get Variable Value      ${config["content"]["thresholds"][1]["direction"]}
    Should Be Equal   ${direction_1}    ${Expected_Direction_2}

Get Configs VDNS Policy
    [Documentation]    Get Config Policy for VDNS
    ${getconfigpolicy}=    Catenate    .*vLoadBalancer*
    ${configpolicy_name}=    Create Dictionary    config_policy_name=${getconfigpolicy}
    ${output} =     Fill JSON Template File     ${GECONFIG_VFW_TEMPLATE}    ${configpolicy_name}
    ${get_resp} =    Run Policy Get Configs Request    ${RESOURCE_PATH_GET_CONFIG}   ${output}
	Should Be Equal As Strings 	${get_resp.status_code} 	200
    ${json}=    Parse Json    ${get_resp.content}
    ${config}=    Parse Json    ${json[0]["config"]}

    # Extract object1 from Array
    ${severity}=    Get Variable Value      ${config["content"]["thresholds"][0]["severity"]}
    Should Be Equal    ${severity}    ${Expected_Severity_3}
    ${Thresold_Value}=    Get Variable Value      ${config["content"]["thresholds"][0]["thresholdValue"]}
    Should Be Equal   ${Thresold_Value}    ${Expected_Threshold_3}
    ${direction}=    Get Variable Value      ${config["content"]["thresholds"][0]["direction"]}
    Should Be Equal   ${direction}    ${Expected_Direction_3}

Teardown Closed Loop
    [Documentation]   Tear down a closed loop test case
    Terminate All Processes
    Teardown VNF
    Log     Teardown complete

Create Config Policy
    [Documentation]    Create Config Policy
    ${randompolicyname} =     Create Policy Name
    ${policyname1}=    Catenate   com.${randompolicyname}
    ${CONFIG_POLICY_NAME}=    Set Test Variable    ${policyname1}
    ${configpolicy}=    Create Dictionary    policy_name=${CONFIG_POLICY_NAME}
    ${output} =     Fill JSON Template File     ${CREATE_CONFIG_TEMPLATE}    ${configpolicy}
    ${put_resp} =    Run Policy Put Request    ${RESOURCE_PATH_CREATE}  ${output}
	Should Be Equal As Strings 	${put_resp.status_code} 	200

 Create Policy Name
     [Documentation]    Generate Policy Name
     [Arguments]    ${prefix}=ETE_
     ${random}=    Generate Random String    15    [LOWER][NUMBERS]
     ${policyname}=    Catenate    ${prefix}${random}
     [Return]    ${policyname}

Create Ops Policy
	[Documentation]    Create Opertional Policy
   	${randompolicyname} =     Create Policy Name
	${policyname1}=    Catenate   com.${randompolicyname}
	${OPS_POLICY_NAME}=    Set Test Variable    ${policyname1}
 	${dict}=     Create Dictionary    policy_name=${OPS_POLICY_NAME}
 	#${NEWPOLICY1}=     Create Dictionary    policy_name=com.${OPS_POLICY_NAME}
	${output} =     Fill JSON Template File     ${CREATE_OPS_TEMPLATE}    ${dict}
    ${put_resp} =    Run Policy Put Request    ${RESOURCE_PATH_CREATE}  ${output}
    Log    ${put_resp}
    Should Be Equal As Strings 	${put_resp.status_code} 	200

Push Ops Policy
    [Documentation]    Push Ops Policy
    [Arguments]    ${policyname}    ${policytype}
    ${dict}=     Create Dictionary     policy_name=${policyname}    policy_type=${policytype}
	${output} =     Fill JSON Template     ${PUSH_POLICY_TEMPLATE}     ${dict}
    ${put_resp} =    Run Policy Put Request    ${RESOURCE_PATH_CREATE_PUSH}  ${output}
    Should Be Equal As Strings 	${put_resp.status_code} 	200

Push Config Policy
    [Documentation]    Push Config Policy
    [Arguments]    ${policyname}    ${policytype}
    ${dict}=     Create Dictionary     policy_name=${policyname}    policy_type=${policytype}
	${output} =     Fill JSON Template     ${PUSH_POLICY_TEMPLATE}     ${dict}
    ${put_resp} =    Run Policy Put Request    ${RESOURCE_PATH_CREATE_PUSH}  ${output}
    Should Be Equal As Strings 	${put_resp.status_code} 	200


Delete Config Policy
    [Documentation]    Delete Config Policy
    [Arguments]    ${policy_name}
    ${policyname3}=    Catenate   com.Config_BRMS_Param_${policyname}.1.xml
    ${dict}=     Create Dictionary     policy_name=${policyname3}
	${output} =     Fill JSON Template     ${DEL_POLICY_TEMPLATE}     ${dict}
    ${put_resp} =    Run Policy Delete Request    ${RESOURCE_PATH_CREATE_DELETE}  ${output}
    Should Be Equal As Strings 	${put_resp.status_code} 	200

Delete Ops Policy
    [Documentation]    Delete Ops Policy
    [Arguments]    ${policy_name}
    ${policyname3}=    Catenate   com.Config_MS_com.vFirewall.1.xml
    ${dict}=     Create Dictionary     policy_name=${policyname3}
	${output} =     Fill JSON Template     ${DEL_POLICY_TEMPLATE}     ${dict}
    ${put_resp} =    Run Policy Delete Request    ${RESOURCE_PATH_CREATE_DELETE}  ${output}
    Should Be Equal As Strings 	${put_resp.status_code} 	200

Orchestrate VNF vFW closedloop
	[Documentation]    VNF Orchestration for vFW
	Log    VNF Orchestration flow TEST NAME=${TEST NAME}
	Setup Orchestrate VNF    ${GLOBAL_AAI_CLOUD_OWNER}    SharedNode    OwnerType    v1    CloudZone
	${stack_name}    ${service}=  Orchestrate VNF   ETE_CLP    vFW      vFW   ${TENANT_NAME}
	[Return]  ${stack_name}

 Orchestrate VNF vDNS closedloop
	[Documentation]    VNF Orchestration for vLB
	Log    VNF Orchestration flow TEST NAME=${TEST NAME}
	Setup Orchestrate VNF    ${GLOBAL_AAI_CLOUD_OWNER}   SharedNode    OwnerType    v1    CloudZone
	${stack_name}    ${service}=  Orchestrate VNF   ETE_CLP    vLB      vLB   ${TENANT_NAME}
	[Return]  ${stack_name}
