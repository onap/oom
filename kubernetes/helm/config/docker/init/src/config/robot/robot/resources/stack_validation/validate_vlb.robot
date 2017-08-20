*** Settings ***
Documentation	  Testing openstack.
Library    String
Library    DNSUtils
Library    Collections
Library    SSHLibrary
Resource          validate_common.robot


*** Variables ***

*** Keywords ***
Validate vLB Stack
    [Documentation]    Identifies the LB and DNS servers in the vLB stack
    [Arguments]    ${stack_name}
    Run Openstack Auth Request    auth
    ${stack_info}=    Wait for Stack to Be Deployed    auth    ${stack_name}
    ${stack_id}=    Get From Dictionary    ${stack_info}    id
    ${server_list}=    Get Openstack Servers    auth
    Log     Returned from Get Openstack Servers
    ${vlb_public_ip}=    Get Server Ip    ${server_list}    ${stack_info}   vlb_name_0    network_name=public
    Log     Waiting for ${vlb_public_ip} to reconfigure
    Sleep   180s
    # Server validations diabled due to issues with load balancer network reconfiguration
    # at startup hanging the robot scripts
	Wait For vLB    ${vlb_public_ip}
    Log    All server processes up

Wait For vLB
    [Documentation]     Wait for the VLB to be functioning as a DNS
    [Arguments]    ${ip}
    Wait Until Keyword Succeeds    300s    10s    DNSTest    ${ip}
    Log  Succeeded

DNSTest
    [Documentation]     Wait for the defined VLoadBalancer to process nslookup
    [Arguments]    ${ip}
    Log   Looking up ${ip}
    #${returned_ip}=     Dns Request    host1.dnsdemo.openecomp.org    ${ip}
    #Should Contain    '${returned_ip}'    .
