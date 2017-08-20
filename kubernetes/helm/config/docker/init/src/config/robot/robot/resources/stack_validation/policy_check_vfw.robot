*** Settings ***
Documentation	  Testing openstack.
Library    OperatingSystem
Library    Process
Library    SSHLibrary
Library    RequestsLibrary
Library    JSONUtils
Library    OpenstackLibrary
Library    HEATUtils
Library    Collections
LIbrary    String
Resource          ../../resources/openstack/keystone_interface.robot
Resource          ../../resources/openstack/nova_interface.robot
Resource          ../../resources/openstack/heat_interface.robot
Resource          ../../resources/ssh/files.robot
Resource          ../../resources/ssh/processes.robot
Resource          packet_generator_interface.robot
Resource          darkstat_interface.robot
Resource          validate_common.robot
Resource          ../../resources/test_templates/vnf_orchestration_test_template.robot


*** Variables ***

*** Keywords ***
Policy Check Firewall Stack
    [Documentation]    Executes the vFW policy closed loop test.
    [Arguments]    ${stack_name}    ${policy_rate}
    Run Openstack Auth Request    auth
    ${stack_info}=    Wait for Stack to Be Deployed    auth    ${stack_name}
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${server_list}=    Get Openstack Servers    auth
    Log     ${server_list}
    ${vpg_unprotected_ip}=    Get From Dictionary    ${stack_info}    vpg_private_ip_0
    ${vsn_protected_ip}=    Get From Dictionary    ${stack_info}    vsn_private_ip_0
    ${vpg_public_ip}=    Get Server Ip    ${server_list}    ${stack_info}   vpg_name_0    network_name=public
    ${vsn_public_ip}=    Get Server Ip    ${server_list}    ${stack_info}   vsn_name_0    network_name=public
    ${upper_bound}=    Evaluate    ${policy_rate}*2
    Wait Until Keyword Succeeds    300s    1s    Run VFW Policy Check    ${vpg_public_ip}   ${policy_rate}    ${upper_bound}    1

Run VFW Policy Check
    [Documentation]     Push traffic above upper bound, wait for policy to fix it, push traffic to lower bound, wait for policy to fix it,
    [Arguments]    ${vpg_public_ip}    ${policy_rate}    ${upper_bound}    ${lower_bound}
    # Force traffic above threshold
    Check For Policy Enforcement    ${vpg_public_ip}    ${policy_rate}    ${upper_bound}
    # Force traffic below threshold
    Check For Policy Enforcement    ${vpg_public_ip}    ${policy_rate}    ${lower_bound}


Check For Policy Enforcement
    [Documentation]     Push traffic above upper bound, wait for policy to fix it, push traffic to lower bound, wait for policy to fix it,
    [Arguments]    ${vpg_public_ip}    ${policy_rate}    ${forced_rate}
    Enable Streams    ${vpg_public_ip}    ${forced_rate}
    Wait Until Keyword Succeeds    20s    5s    Test For Expected Rate    ${vpg_public_ip}    ${forced_rate}
    Wait Until Keyword Succeeds    280s    5s    Test For Expected Rate    ${vpg_public_ip}    ${policy_rate}

Test For Expected Rate
    [Documentation]    Ge the number of pg-streams from the PGN, and test to see if it is what we expect.
    [Arguments]    ${vpg_public_ip}    ${number_of_streams}
    ${list}=    Get List Of Enabled Streams    ${vpg_public_ip}
    ${list}=    Evaluate   ${list['sample-plugin']}['pg-streams']['pg-stream']
    Length Should Be    ${list}    ${number_of_streams}



Policy Check vLB Stack
    [Documentation]    Executes the vLB policy closed loop test
    [Arguments]    ${stack_name}    ${policy_rate}
    Run Openstack Auth Request    auth
    ${stack_info}=    Wait for Stack to Be Deployed    auth    ${stack_name}
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${server_list}=    Get Openstack Servers    auth
    ${vlb_public_ip}=    Get Server Ip    ${server_list}    ${stack_info}   vlb_name_0    network_name=public
    ${upper_bound}=    Evaluate    ${policy_rate}*2
    Start DNS Traffic    ${vlb_public_ip}    ${upper_bound}

    # Now wiat for the dnsscaling stack to be deployed
    ${prefix}=    Get DNSScaling Prefix
    ${dnsscaling}=    Replace String Using Regexp    ${stack_name}    ^Vfmodule_    ${prefix}
    ${dnsscaling_info}=    Wait for Stack to Be Deployed    auth    ${dnsscaling}
    VLB Closed Loop Hack Update   ${dnsscaling}
    # TO DO: Log into vLB and cehck that traffic is flowing to the new DNS
    [Return]    ${dnsscaling}

Get DNSScaling Prefix
    ${mapping}=    Get From Dictionary   ${GLOBAL_SERVICE_TEMPLATE_MAPPING}   vLB
    :for   ${dict}    in   @{mapping}
    \    Return From Keyword If    '${dict['isBase']}' == 'false'    ${dict['prefix']}
    [Return]   None


Start DNS Traffic
    [Documentation]   Run nslookups at rate per second. Run for 10 minutes or until it is called by the terminate process
    [Arguments]    ${vlb_public_ip}    ${rate}
    ${pid}=   Start Process   ./dnstraffic.sh   ${vlb_public_ip}   ${rate}   ${GLOBAL_DNS_TRAFFIC_DURATION}
    [Return]    ${pid}